util = require('util')
winston = require('winston')

class DeployTransport extends winston.Transport
  constructor: (options) ->
    @name = 'DeployTransport'
    @level = options.level or 'info'

    @stream = options.stream

  log: (level, msg, meta, callback) ->
    @stream.write "#{msg}\n"
    callback null, true

winston.transports.DeployTransport = DeployTransport
module.exports = DeployTransport