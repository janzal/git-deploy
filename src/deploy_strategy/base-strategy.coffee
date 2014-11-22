{exec} = require 'child_process'
async = require 'async'

class BaseStrategy
  constructor: (@application, @repository, @config, @logger) ->

  deploy: (callback) ->
    callback new Error "Not implement yet"


  processCommands_: (commands, callback) ->
    console.log commands
    async.eachSeries commands, ((cmd, callback) =>
      command = cmd
      options = {}

      unless typeof cmd is 'string'
        command = cmd.command
        options = cmd.options

      callback() # child = exec command, options, callback
      # child.stdout.pipe process.stdout
      # child.stderr.pipe proceess.stderr

      @logger.info "#{@application.name} from #{@repository.name}: #{command}"
    ), ((err) =>
      callback err
    )

module.exports = BaseStrategy
