BaseStrategy = require './base-strategy'

class HardcoreStrategy extends BaseStrategy
  deploy: (callback) ->
    callback = (()->) unless callback?

    commands = @prepareCommands_()

    @processCommands_ commands, (err) =>
      @logger.error err if err
      callback(err)


  prepareCommands_: () ->
    temp_path = "#{@config.temp}/#{@application}"

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