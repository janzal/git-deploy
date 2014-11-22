GitDeploy = require './git-deploy'
HandlerFactory = require './handlers/handler-factory'
StrategyFactory = require './deploy_strategy/strategy-factory'

class DeployController
  constructor: () ->

  deploy: (req, res, next) ->
    res.write "Deploying application #{req.params.application}\n"
    application_config = req.config.applications[req.params.application]

    unless application_config?
      return next new Error "Unkown application name #{req.params.application}"

    application_config.name = req.params.application
    handlerFactory = new HandlerFactory req.body

    handler
    try
      handler = handlerFactory.getHandlerByName application_config.handler
    catch error
      return next error

    repository = handler.extractRepositoryInfo()

    strategyFactory = new StrategyFactory application_config, repository, req.config, req.logger
    strategy
    try
      strategy = strategyFactory.getStrategyByName application_config.strategy
    catch error
      return next error

    gitDeploy = new GitDeploy application_config, repository, strategy, req.config, req.logger
    gitDeploy.run (err) ->
      return next err if err?
      req.logger.info "App has been deployed!"
      res.end "Successfully deployed!\n"
      next()

  handlePostDeploy: (req, res, next) ->


module.exports = DeployController;