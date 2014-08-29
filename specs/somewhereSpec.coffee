'use strict'

expect = require('chai').expect
db = require '../index'

describe "JSONdb module", ->
  beforeEach ->
    db.connect('./mochaTest.json')

  it "should save and write an item", ->
    user =
      username: 'dreyacosta'
      name: 'David'
      blog: 'dreyacosta.com'
      source: 'twitter'
    item = db.save 'users', user
    expect(item.username).to.equal 'dreyacosta'

  it "should find one", ->
    item = db.findOne 'users', { username: 'dreyacosta' }
    expect(item.name).to.equal 'David'

  it "should find all", ->
    user =
      username: 'drey'
      name: 'David'
      blog: 'drey.com'
      source: 'twitter'
    item = db.save 'users', user
    items = db.find 'users', { name: 'David' }
    expect(items.length).to.equal 2

  it "should return an empty object if no match on find one", ->
    item = db.findOne 'users', { name: 'Paul' }
    expect(typeof item).to.equal 'object'
    expect(Object.keys(item).length).to.equal 0

  it "should return an empty array if no match on find all", ->
    items = db.find 'users', { name: 'Paul' }
    expect(items.push).to.be.a 'function'
    expect(items.length).to.equal 0

  it "should return a pure object when find one", ->
    item = db.findOne 'users', { username: 'dreyacosta' }
    expect(item.name).to.equal 'David'
    item.name = 'Mike'
    item = db.findOne 'users', { username: 'dreyacosta' }
    expect(item.name).to.equal 'David'

  it "should return a pure array when find all", ->
    user =
      username: 'pirish'
      name: 'Paul'
      blog: 'pirish.com'
      source: 'twitter'
    item = db.save 'users', user
    items = db.find 'users', { source: 'twitter' }
    expect(items.length).to.equal 3
    items[0].source = 'facebook'
    items = db.find 'users', { source: 'twitter' }
    expect(items.length).to.equal 3

  it "should return a pure object when update", ->
    item = db.findOne 'users', { username: 'dreyacosta' }
    item = db.update 'users', item.id, { name: 'David Rey' }
    expect(item.name).to.equal 'David Rey'
    item.name = 'Mike'
    item = db.findOne 'users', { username: 'dreyacosta' }
    expect(item.name).to.equal 'David Rey'

  it "should update item", ->
    data =
      country: 'Spain'
    item = db.findOne 'users', { username: 'drey' }
    item = db.update 'users', item.id, data
    expect(item.country).to.equal 'Spain'

  it "should remove item from a collection", ->
    item = db.findOne 'users', { username: 'drey' }
    expect(item.username).to.equal 'drey'
    result = db.remove 'users', item.id
    expect(result).to.equal true
    item = db.findOne 'users', { id: item.id }
    expect(typeof item).to.equal 'object'
    expect(Object.keys(item).length).to.equal 0

  it "should clear the database file", ->
    db.clear()