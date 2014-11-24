class BaseHandler
  @canHandle: (info) ->
    throw new Error 'Not implemented yet'

  constructor: (@info) ->

  extractRepositoryInfo: () ->
    throw new Error 'Not implemented yet'

module.exports = BaseHandler;