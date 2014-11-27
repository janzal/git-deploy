BaseHandler = require './base-handler'

class GithubHandler extends BaseHandler
  @canHandle: (info) ->
    url = info.repository?.url

    /github\.com/.test url

  extractRepositoryInfo: (info) ->
    branches = {}
    refs = info.ref.split "/"
    branch = refs[2]

    for commit in info.commits
      branches[branch] = [] unless branches[branch]?
      branches[branch].push commit

    result =
      branches: branches
      url: info.repository.ssh_url
      name: info.repository.name
      author: info.owner.name

module.exports = GithubHandler;