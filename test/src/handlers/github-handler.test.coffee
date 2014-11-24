{expect}  = require 'chai'
GithubHandler = require "../../../src/handlers/github-handler"
github_payload = require "../../data/github_payload.json"
bitbucket_payload = require "../../data/bitbucket_payload.json"

describe "github handler", ->
  describe "#canHandle", ->
    it "should detect github handle", ->
      handle = GithubHandler.canHandle github_payload

      expect(handle).to.be.ok

    it "should not detect github handle", ->
      handle = GithubHandler.canHandle bitbucket_payload

      expect(handle).not.to.be.ok

    it "should not detect github handle", ->
      handle = GithubHandler.canHandle {}

      expect(handle).not.to.be.ok

  describe "#extractRepositoryInfo", ->
    handler = new GithubHandler github_payload

    it "should extract branches"
      info = handler.extractRepositoryInfo()

      expect(info.branches['gh-pages']).to.be.instanceof Array