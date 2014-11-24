GitDeploy = require './git-deploy'
HandlerFactory = require './handlers/handler-factory'
StrategyFactory = require './deploy_strategy/strategy-factory'
DeployTransport = require './deploy-transport'
winston = require 'winston'

class DeployController
  constructor: () ->

  deploy: (req, res, next) ->
    application_config = req.application_config

    logger = req.loggers[application_config.name]
    logger.add DeployTransport, {
      stream: res
      level: "debug"
    }

    logger.info "Deploying application #{req.params.application}"

    handlerFactory = new HandlerFactory req.body

    handler
    try
      handler = handlerFactory.getHandlerByName application_config.handler
    catch error
      return next error

    repository = handler.extractRepositoryInfo()

    strategyFactory = new StrategyFactory application_config, repository, req.config, logger
    strategy
    try
      strategy = strategyFactory.getStrategyByName application_config.strategy
    catch error
      return next error

    gitDeploy = new GitDeploy application_config, repository, strategy, req.config, logger
#    logger.info "Deploy of #{application_config.name} started"
    gitDeploy.run (err) ->
      if err
        logger.error "Error occured during deploy.", err
        res.end "Application has not been deployed\n"
        return next()

      logger.info "App #{application_config.name} has been deployed!"
      res.end "Successfully deployed!\n"
      next()

  handlePostDeploy: (req, res, next) ->
    logger = req.loggers[req.application_config.name]
    logger.remove DeployTransport
    next()

module.exports = DeployController;