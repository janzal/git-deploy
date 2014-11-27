BaseHandler = require './base-handler'

class BitbucketHandler extends BaseHandler
  extractPayload: (request) ->
    console.log request.body

    request.body.payload

  extractRepositoryInfo: (info) ->
    branches = {}

    for commit in info.commits
      branches[commit.branch] = [] unless branches[commit.branch]?

      branches[commit.branch].push commit

    result =
      branches: branches
      url: "git@bitbucket.org:#{info.repository.owner}/#{info.repository.slug}.git"
      name: info.repository.name
      author: info.user

module.exports = BitbucketHandler;