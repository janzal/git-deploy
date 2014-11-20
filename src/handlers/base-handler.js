var BaseHandler;

BaseHandler = (function() {
  function BaseHandler() {}

  BaseHandler.prototype.extractRepositoryInfo = function(info) {
    throw new Error('Not implemented yet');
  };

  return BaseHandler;

})();

module.exports = BaseHandler;
