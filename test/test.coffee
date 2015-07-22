{SmartProp, SmartObject} = require "../coffee/smartprop.coffee"
require "coffee-script/register"
chai = require 'chai'
chai.should()

describe 'SmartProp', ->
  it "should return basic value", ->
    sp = new SmartProp("name")
    sp.get {yo: 2, name: "chris"}
      .should.be.equal("chris")

  it "should return nested value", ->
    sp = new SmartProp("name")
    sp.get {yo: 2, yo2: 0, yo4: { huh: 3, name: "chris"}}
      .should.be.equal("chris")

  it "should throw on ambiguity", ->
    sp = new SmartProp("name")
    (-> sp.get {yo: 2, yo2: { bu: 3, name: "chris"}, yo4: { huh: 3, name: "chris"}}).should.throw(/ambiguous/)

  it "should work with regex", ->
    sp =  new SmartProp(/star/)
    sp.get {yo: 2, yo2: 0, yo4: { huh: 3, stargazer: "chris"}}
      .should.be.equal("chris")

  it "has cache", ->
    sp = new SmartProp("name")
    sp.get {yo: 2, yo2: 0, yo4: { huh: 3, name: "chris"}}
    sp.cache.should.be.deep.equal(["yo4", "name"])

  it "uses the cache", ->
    sp = new SmartProp("name")
    result = sp.get {yo: 2, yo2: 0, yo4: { huh: 3, name: "chris"}}
    sp.foundOnce.should.be.equal(true)
    result2 = sp.get {yo: 2, yo2: 0, yo4: { huh: 3, name: "chris"}}
    result.should.be.equal(result2)
    sp.cache.should.be.deep.equal(["yo4", "name"])

describe "SmartObject", ->
  it "maps the simple objects", ->
    so = new SmartObject {name: /name/}
    so.obj.name.should.be.instanceOf(SmartProp)
  it "works the way it should", ->
    so = new SmartObject {name: /name/}
    so.map {yo: 2, yo2: 0, yo4: { huh: 3, name: "chris"}}
      .should.be.deep.equal {name: "chris"}