{exec} = require 'child_process'
{EventEmitter} = require 'events'
async = require 'async'
mkdirp = require 'mkdirp'

class GitDeploy extends EventEmitter
  @EventTypes =
    pre_deploy: "pre_deploy",
    post_deploy: "post_deploy"


  constructor: (@application, @repository, @strategy, @config, @logger) ->
    super()


  run: (callback) ->
    callback = (()->) unless callback?

    branches = Object.keys @repository.branches
    deployed_branches = (branch for branch in branches when @application.branches[branch]?)

    async.each deployed_branches, ((branch, callback) =>
      @emit GitDeploy.EventTypes.pre_deploy, branch

      @logger.info "Deploying branch #{branch}"
      branch_config = @application.branches[branch];

      @processDeploy_ branch, branch_config, callback
    ), callback

  loadDeployfile: () ->
    
  processDeploy_: (branch, branch_config, callback) ->
    async.series [

      (callback) =>
        @logger.deploy "Creating destination folder"
        mkdirp branch_config.destination, callback

      (callback) =>
        if branch_config.pre_deploy
          @logger.deploy "Executing predeploy"
          @logger.command "#{branch_config.pre_deploy}"
          exec branch_config.pre_deploy, cwd: branch_config.destination, (err, so, se) =>
            @logger.deploy so if so
            @logger.error se if se
            callback err
        else
          callback null

      (callback) =>
        @logger.deploy "Deploying"
        @deployBranch_ branch, callback

      (callback) =>
        if branch_config.post_deploy
          @logger.deploy "Executing postdeploy"
          @logger.command "#{branch_config.post_deploy}"
          exec branch_config.post_deploy, cwd: branch_config.destination, (err, so, se) =>
            @logger.deploy so if so
            @logger.error se if se
            callback err
        else
          callback null

    ], callback

  deployBranch_: (branch, callback) ->
    @strategy.deploy branch, ((err) =>
          if err
            @logger.error "Cannot deploy branch #{branch}"
          else
            @logger.info "Deploy of branch #{branch} finished"
          @emit GitDeploy.EventTypes.post_deploy, branch, err
          callback err
        ), callback

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
