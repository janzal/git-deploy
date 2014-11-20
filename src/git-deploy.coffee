{EventEmitter} = require 'events'
{exec} = require 'child_process'
async = require 'async'

class GitDeploy extends EventEmitter
  @EventTypes =
    pre_deploy: "pre_deploy",
    post_deploy: "post_deploy"


  constructor: (@application, @repository, @config, @logger) ->
    super()


  deploy: (callback) ->
    callback = (()->) unless callback?

    unless @config.applications[@application]?
      return callback(new Error("Application '#{@application}' is not configured"))

    @emit GitDeploy.EventTypes.pre_deploy

    commands = @prepareCommands_()

    @processCommands_ commands, (err) =>
      @emit GitDeploy.EventTypes.post_deploy, err
      @logger.error err if err
      callback(err)


  prepareCommands_: () ->
    temp_path = "#{@config.temp}/#{@application}"

    [
      "rm -rf #{temp_path}"
      "mkdir -p #{temp_path}"
      {
        command: "git init",
        options: {
          cwd: temp_path
        }
      },
      {
        command: "git remote add origin #{@repository.url}",
        options: {
          cwd: temp_path
        }
      },
      {
        
      }
    ]


  processCommands_: (commands, callback) ->
    async.eachSeries commands, ((cmd, callback) =>
      command = cmd
      options = {}

      unless typeof cmd is 'string'
        command = cmd.command
        options = cmd.options

      child = exec command, options, callback
      child.stdout.pipe process.stdout
      child.stderr.pipe proceess.stderr
    ), ((err) =>
      callback err
    )

#  # make a new blank repository in the current directory
#git init
#
## add a remote
#git remote add origin url://to/source/repository
#
## fetch a commit (or branch or tag) of interest
## Note: the full history of this commit will be retrieved
#git fetch origin <sha1-of-commit-of-interest>
#
#  # reset this repository's master branch to the commit of interest
#  git reset --hard FETCH_HEAD
#
#module.exports = GitDeploy