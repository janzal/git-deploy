express = require("express")
program = require("commander")
winston = require("winston")
info = require("../package.json")
path = require "path"

# controllers
DeployController = require("../src/deploy-controller")

# arguments
program
  .version info.version
  .usage "[options] <configuration>"
  .option "-p, --port <port>", "Port"
  .parse process.argv

# instatiate logger
logger = new (winston.Logger)(transports: [ new (winston.transports.Console)(colorize: true),
                                            new (winston.transports.File)(filename: "./deploy.log"
                                                                          timestamp: true
                                            ) ])

# load config
unless program.args[0]?
  logger.error "You have to define config file. Run with -h for help"
  process.exit 1

config_path = path.join __dirname, program.args[0]

logger.debug "config path is #{config_path}"
config = require config_path

# create new app
app = express()

# add logger
app.use (req, res, next) ->
  req.logger = logger

# controllers
deployController = new DeployController()

# routes
app.get "/deploy/:", deployController.deploy.bind deployController

# ...and start listening
server = app.listen program.port or 3929, ->
  host = server.address().address
  port = server.address().port
  console.log()
  console.log "<<<< git-deploy >>>>>"
  console.log()
  logger.info "listening at http://%s:%s", host, port

