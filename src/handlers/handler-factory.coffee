BitbucketHandler = require './bitbucket-handler'
GithubHandler = require './github-handler'

class HandlerFactory
  @handlers =
    bitbucket: BitbucketHandler
    github: GithubHandler

  constructor: (@info) ->

  getHandlerByName: (name) ->
    switch name
      when "bitbucket" then new BitbucketHandler @info
      else throw new Error "Unknown handler #{name}"

  detectHandler: () ->
#    for name, handler in
module.exports = HandlerFactory
