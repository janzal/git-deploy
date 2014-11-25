util = require('util')
winston = require('winston')

class DeployTransport extends winston.Transport
  constructor: (options) ->
    @name = 'DeployTransport'
    @level = options.level or 'info'

    @stream = options.stream

  renderObject: (object, depth = 1) ->
    result = []
    keys = Object.keys object

    for key in keys
      result.push "#{key}=#{object[key]}"

    "(#{result.join ", "})" if result.length

  log: (level, msg, meta, callback) ->
    @stream.write "error: " if level is "error"
    @stream.write "\# " if level is "command"

    @stream.write "#{msg}"

    stringified_meta = @renderObject meta
    @stream.write " #{stringified_meta}" if stringified_meta

    @stream.write "\n"
    callback null, true

winston.transports.DeployTransport = DeployTransport
module.exports = DeployTransport