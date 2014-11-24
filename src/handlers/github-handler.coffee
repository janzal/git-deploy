BaseHandler = require './base-handler'

class GithubHandler extends BaseHandler
  @canHandle: (info) ->
    url = info?.repository?.url?

    /github\.com/.test url

  extractRepositoryInfo: () ->
    branches = {}

    for commit in @info.commits
      branches[commit.branch] = [] unless branches[commit.branch]?

      branches[commit.branch].push commit

    result =
      branches: branches
      url: @info.repository.ssh_url
      name: @info.repository.name
      author: @info.owner.name

module.exports = GithubHandler;