express = require("express")
program = require("commander")
winston = require("winston")
info = require("../package.json")
BodyParser = require("body-parser")
fs = require "fs"
path = require "path"
yaml = require "js-yaml"
auth = require('http-auth');

# controllers
DeployController = require("../src/deploy-controller")
WebUiController = require("../src/web-ui-controller")

# arguments
program
  .version info.version
  .usage "[options] <configuration>"
  .option "-p, --port <port>", "Port"
  .parse process.argv

# instatiate logger
levels =
  silly: 0,
  debug: 1,
  verbose: 2,
  command: 3,
  deploy: 4,
  info: 5,
  warn: 6,
  error: 7

colors = JSON.parse JSON.stringify winston.config.npm.colors
colors.deploy = "cyan"
colors.command = "magenta"


transports = [
  new (winston.transports.Console)(colorize: true, level: "debug"),
  new (winston.transports.File)({filename: "./deploy.log", timestamp: true, json: false, level: "debug"})
]

logger_options =
  levels: levels
  colors: colors
  transports: transports

logger = new (winston.Logger)(logger_options)

# load config
unless program.args[0]?
  logger.error "You have to define config file. Run with -h for help"
  process.exit 1

config_path = path.join process.cwd(), program.args[0]

logger.debug "config path is #{config_path}"

# loading config
config
extname = (path.extname config_path).toLowerCase()
try
  file_content = fs.readFileSync config_path, "utf8"

  switch extname
    when ".yaml" then config = yaml.safeLoad file_content
    when ".json" then config = JSON.parse file_content
    else throw new Error "Cannot open config in this format. Detected extension '#{extname}'. YAML and JSON are supported"
catch error
  logger.error "Cannot open config file '#{config_path}'. Due to error '#{error.message}'"
  process.exit 1

# create logger for each application
applications = Object.keys config.applications

loggers = {}
for application in applications
  logger.debug "Adding logger for #{application}"
  loggers[application] = new winston.Logger logger_options

# create new app
app = express()

# get routers
hook_router = express.Router()
ui_router = express.Router()

# rendering engine and views
app.set('view engine', 'html')
app.engine('html', require('hbs').__express)

# load users
basic = auth.basic({
    realm: "git-deploy:#{config.server_name}",
    }, (user, password, success) ->
        success config.auth[user] is password
      )

ui_router.use auth.connect basic if config.auth?

# add logger
app.use (req, res, next) ->
  req.logger = logger
  next()

# add app loggers
app.use (req, res, next) ->
  req.loggers = loggers
  next()

# add config
app.use (req, res, next) ->
  req.config = config
  next()

# add json body parser
hook_router.use BodyParser.json()

# add urlencoded body parser
hook_router.use BodyParser.urlencoded()

# controllers
deployController = new DeployController()
webUiController = new WebUiController()

# routes
# ui routes
ui_router.get "", webUiController.isRunning.bind webUiController

# hook params
hook_router
  .param "application", (req, res, next, application) ->
    req.application_config = req.config.applications[application]

    unless req.application_config
      return next new Error "Unkown application name #{application}"

    req.application_config.name = application
    next()

# hook routes
hook_router
  .route "/deploy/:application"
  .post deployController.deploy.bind deployController
  .all deployController.handlePostDeploy.bind deployController

# apply routers to app
app.use "/hooks", hook_router
app.use "/", ui_router if config.ui

# ...and start listening
server = app.listen program.port or config.port or 3929, ->
  host = server.address().address
  port = server.address().port
  console.log()
  console.log "<<<< git-deploy >>>>>"
  console.log()
  logger.info "#{config.server_name} is listening at http://%s:%s", host, port

