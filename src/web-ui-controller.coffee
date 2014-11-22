class WebUiController
  
  isRunning: (req, res, next) ->
    res.render "running",
      config: req.config
      url: "#{req.protocol}://#{req.get('host')}#{req.originalUrl}"

module.exports = WebUiController