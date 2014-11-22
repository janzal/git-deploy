{exec} = require 'child_process'
{EventEmitter} = require 'events'
async = require 'async'

class GitDeploy extends EventEmitter
  @EventTypes =
    pre_deploy: "pre_deploy",
    post_deploy: "post_deploy"


  constructor: (@application, @repository, @strategy, @config, @logger) ->
    super()


  run: (callback) ->
    callback = (()->) unless callback?

    unless @config.applications[@application]?
      return callback(new Error("Application '#{@application}' is not configured"))

    @emit GitDeploy.EventTypes.pre_deploy
    @strategy.deploy @application, @repository, @config, @logger
    @emit GitDeploy.EventTypes.post_deploy, err
    @logger.error err if err
    callback(err)

module.exports = GitDeploy

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
