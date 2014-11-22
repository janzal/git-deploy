BaseHandler = require './base-handler'

class BitbucketHandler extends BaseHandler
  constructor: (@info) ->

  extractRepositoryInfo: () ->
    result =
      url: "git://bitbucket.org/#{@info.repository.absolute_url}"
      name: @info.repository.name
      author: @info.user

module.exports = BitbucketHandler;