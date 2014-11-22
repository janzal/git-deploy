class BaseHandler
  constructor: (@info) ->

  extractRepositoryInfo: () ->
    throw new Error 'Not implemented yet'

module.exports = BaseHandler;