class DeployController
  constructor: () ->

  deploy: (req, res, next) ->
    res.send "Successfuly deployed"


module.exports = DeployController;