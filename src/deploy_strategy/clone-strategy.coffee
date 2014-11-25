BaseStrategy = require "./base-strategy"

class CloneStrategy extends BaseStrategy

  prepareCommands_: (branch) ->
    temp_path = "#{@config.temp}/#{@application.name}/#{branch}"
    dest = @application.branches[branch]['destination']

    throw new Error "Temp path #{temp_path} is dangerous" if @checkDangerousPath temp_path
    if @checkDangerousPath dest
      throw new Error "Destination path #{dest} is dangerous"

    [
      "rm -rf #{dest}"
      "rm -rf #{temp_path}"
      "mkdir -p #{temp_path}"
      {
       command: "git status || git clone -b #{branch} --single-branch --depth 1 #{@repository.url} ./"
       options:
         cwd: temp_path
      },
      "mv #{temp_path} #{dest}"
    ]

module.exports = CloneStrategy