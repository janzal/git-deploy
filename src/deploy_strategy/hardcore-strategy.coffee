BaseStrategy = require './base-strategy'
async = require 'async'

class HardcoreStrategy extends BaseStrategy


  prepareCommands_: (branch) ->
    temp_path = "#{@config.temp}/#{@application.name}/#{branch}"

    [
      "rm -rf #{temp_path}"
      "mkdir -p #{temp_path}"
      {
        command: "git init",
        options: {
          cwd: temp_path
        }
      },
      {
        command: "git remote add origin #{@repository.url}",
        options: {
          cwd: temp_path
        }
      },
      {
        command: "git fetch origin "
      }
    ]

module.exports = HardcoreStrategy
#  # make a new blank repository in the current directory
#git init
#
## add a remote
#git remote add origin url://to/source/repository
#
## fetch a commit (or branch or tag) of interest
## Note: the full history of this commit will be retrieved
#git fetch origin <sha1-of-commit-of-interest>
#
#  # reset this repository's master branch to the commit of interest
#  git reset --hard FETCH_HEAD
#
#module.exports = GitDeploy