{exec} = require 'child_process'
async = require 'async'

class BaseStrategy
  constructor: (@application, @repository, @config, @logger) ->

  deploy: (branch, callback) ->
    callback = (()->) unless callback?

    commands = @prepareCommands_ branch

    @processCommands_ branch, commands, (err) =>
      callback(err)

  prepareCommands_: (branch) ->
    throw new Error "Method not implemented yet"

  checkDangerousPath: (path) ->
    return true if path == "//"

    return false

  processCommands_: (branch, commands, callback) ->
    async.eachSeries commands, ((cmd, callback) =>
      command = cmd
      options = null

      unless typeof cmd is 'string'
        command = cmd.command
        options = cmd.options

      @logger.deploy "#{@application.name}\##{branch} from #{@repository.name}: #{command}"
      child = exec command, options, callback

      child.stderr.on "data", (data) =>
        @logger.error "#{data}"
      child.stdout.on "data", (data) =>
        @logger.deploy "#{data}"
    ), ((err) =>
      callback err
    )

module.exports = BaseStrategy
