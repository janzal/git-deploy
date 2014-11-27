BitbucketHandler = require './bitbucket-handler'
GithubHandler = require './github-handler'

class HandlerFactory
  @handlers =
    bitbucket: BitbucketHandler
    github: GithubHandler

  constructor: () ->

  getHandlerByName: (name) ->
    switch name
      when "bitbucket" then new BitbucketHandler()
      when "github" then new GithubHandler()
      else throw new Error "Unknown handler #{name}"

  detectHandler: (payload) ->
#    for name, handler in HandlerFactory.handlers
#      handler.canHandle

module.exports = HandlerFactory
