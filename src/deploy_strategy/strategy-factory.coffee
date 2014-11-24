HardcoreStrategy = require './hardcore-strategy'
CloneStrategy = require './clone-strategy'

class StrategyFactory
  constructor: (@application, @repository, @config, @logger) ->

  getStrategyByName: (name) ->
    switch name
      when "hardcore" then new HardcoreStrategy @application, @repository, @config, @logger
      when "clone" then new CloneStrategy @application, @repository, @config, @logger
      else throw new Error "Unknown handler #{name}"

module.exports = StrategyFactory