class BaseHandler
  @canHandle: (info) ->
    throw new Error 'Not implemented yet'

  constructor: () ->

  extractPayload: (request) ->
    throw new Error "Not implemented yet"

  extractRepositoryInfo: (info) ->
    throw new Error 'Not implemented yet'

module.exports = BaseHandler;