{exec} = require 'child_process'
async = require 'async'

class BaseStrategy
  constructor: (@application, @repository, @config, @logger) ->

  deploy: (callback) ->
    callback new Error "Not implement yet"


  processCommands_: (branch, commands, callback) ->
    async.eachSeries commands, ((cmd, callback) =>
      command = cmd
      options = {}

      unless typeof cmd is 'string'
        command = cmd.command
        options = cmd.options

      setTimeout (()->
        callback()), (100 * Math.random())
      # child = exec command, options, callback
      # child.stdout.pipe process.stdout
      # child.stderr.pipe proceess.stderr

      @logger.deploy "#{@application.name}\##{branch} from #{@repository.name}: #{command}"
    ), ((err) =>
      callback err
    )

module.exports = BaseStrategy
