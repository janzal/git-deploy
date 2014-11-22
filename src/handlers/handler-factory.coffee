BitbucketHandler = require './bitbucket-handler'

class HandlerFactory
  constructor: (@info) ->

  getHandlerByName: (name) ->
    switch name
      when "bitbucket" then new BitbucketHandler @info
      else throw new Error "Unknown handler #{name}"

module.exports = HandlerFactory