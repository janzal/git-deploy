var DeployController, app, config, config_path, deployController, express, info, logger, path, program, server, winston;

express = require("express");

program = require("commander");

winston = require("winston");

info = require("./package.json");

path = require("path");

DeployController = require("./src/deploy-controller");

program.version(info.version).usage("[options] <configuration>").option("-p, --port <port>", "Port").parse(process.argv);

logger = new winston.Logger({
  transports: [
    new winston.transports.Console({
      colorize: true
    }), new winston.transports.File({
      filename: "./deploy.log",
      timestamp: true
    })
  ]
});

if (program.args[0] == null) {
  logger.error("You have to define config file. Run with -h for help");
  process.exit(1);
}

config_path = path.join(__dirname, program.args[0]);

logger.debug("config path is " + config_path);

config = require(config_path);

app = express();

app.use(function(req, res, next) {
  return req.logger = logger;
});

deployController = new DeployController();

app.get("/deploy/:", deployController.deploy.bind(deployController));

server = app.listen(program.port || 3929, function() {
  var host, port;
  host = server.address().address;
  port = server.address().port;
  console.log();
  console.log("<<<< git-deploy >>>>>");
  console.log();
  return logger.info("listening at http://%s:%s", host, port);
});
