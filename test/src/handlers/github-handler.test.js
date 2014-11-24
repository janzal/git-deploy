// Generated by CoffeeScript 1.8.0
(function() {
  var GithubHandler, bitbucket_payload, expect, github_payload;

  expect = require('chai').expect;

  GithubHandler = require("../../../src/handlers/github-handler");

  github_payload = require("../../data/github_payload.json");

  bitbucket_payload = require("../../data/bitbucket_payload.json");

  describe("github handler", function() {
    describe("#canHandle", function() {
      it("should detect github handle", function() {
        var handle;
        handle = GithubHandler.canHandle(github_payload);
        return expect(handle).to.be.ok;
      });
      it("should not detect github handle", function() {
        var handle;
        handle = GithubHandler.canHandle(bitbucket_payload);
        return expect(handle).not.to.be.ok;
      });
      return it("should not detect github handle", function() {
        var handle;
        handle = GithubHandler.canHandle({});
        return expect(handle).not.to.be.ok;
      });
    });
    return describe("#extractRepositoryInfo", function() {
      var handler;
      handler = new GithubHandler(github_payload);
      return it("should extract branches");
    });
  });

}).call(this);

//# sourceMappingURL=github-handler.test.js.map
