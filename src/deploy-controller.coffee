GitDeploy = require './git-deploy'
HandlerFactory = require './handlers/handler-factory'

class DeployController
  constructor: () ->

  deploy: (req, res, next) ->
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

    gitDeploy = new GitDeploy application_config, repository, application_config.strategy, req.config, req.logger
    gitDeploy.run (err) ->
      return next err unless err?

      res.send "Successfully deployed!"


module.exports = DeployController;