var util = require('util'),
  winston = require('winston');

var DeployLogger = winston.transports.DeployLogger = function (options) {
  this.name = 'deployLogger';
this.level = options.level || 'info';

this.stream = options.stream;
};

DeployLogger.prototype.name = 'deployLogger';

util.inherits(DeployLogger, winston.Transport);

DeployLogger.prototype.log = function (level, msg, meta, callback) {
this.stream.write(msg + "\n");
callback(null, true);
};

module.exports = DeployLogger;