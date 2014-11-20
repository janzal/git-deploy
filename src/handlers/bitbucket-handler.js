var BaseHandler, BitbucketHandler,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

BaseHandler = require('./base-handler');

BitbucketHandler = (function(_super) {
  __extends(BitbucketHandler, _super);

  function BitbucketHandler() {
    return BitbucketHandler.__super__.constructor.apply(this, arguments);
  }

  BitbucketHandler.prototype.extractRepositoryInfo = function(info) {
    var result;
    return result = {
      url: "git://bitbucket.org/" + info.repository.absolute_url,
      name: info.repository.name,
      author: info.user
    };
  };

  return BitbucketHandler;

})(BaseHandler);

module.exports = BitbucketHandler;
