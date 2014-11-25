{exec} = require 'child_process'
{EventEmitter} = require 'events'
async = require 'async'
mkdirp = require 'mkdirp'
path = require 'path'
yaml = require 'js-yaml'
fs = require 'fs'

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

  loadDeployfile: (dest_path) ->
    config_path = path.join dest_path, ".deployfile"

    return null unless fs.existsSync config_path

    config
    try
      file_content = fs.readFileSync config_path, "utf8"
      config = yaml.safeLoad file_content
    catch error
      @logger.error "Cannot load .deployfile"

    config
    
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
        async.waterfall [
          (callback) =>
            return callback null, null unless @application.allow_deployfile

            deployfile = @loadDeployfile branch_config.destination
            if deployfile?[branch]
              @logger.deploy "Using .deployfile post deploy"
              if deployfile[branch].override
                @logger.info "Default post deploy is overriden"
              command = deployfile[branch].post_deploy
              @logger.command "#{command}"
              exec command, cwd: branch_config.destination, (err, so, se) =>
                @logger.deploy so if so
                @logger.error se if se
                callback err, deployfile
            else
              callback null, deployfile

          (deployfile, callback) =>
            if branch_config.post_deploy and (not deployfile? or not deployfile?[branch]?.override)
              @logger.deploy "Executing postdeploy"

              @logger.command "#{branch_config.post_deploy}"
              exec branch_config.post_deploy, cwd: branch_config.destination, (err, so, se) =>
                @logger.deploy so if so
                @logger.error se if se
                callback err
            else
              callback null
        ], callback
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
