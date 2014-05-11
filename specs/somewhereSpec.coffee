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
    item = db.save 'users', user
    items = db.find 'users', { name: 'David' }
    expect(items.length).to.equal 2

  it "should update item", ->
    data =
      country: 'Spain'
    item = db.findOne 'users', { username: 'drey' }
    item = db.update 'users', item.id, data
    expect(item.country).to.equal 'Spain'

  it "should remove item from a collection", ->
    item = db.findOne 'users', { username: 'drey' }
    expect(item.username).to.equal 'drey'

    db.remove 'users', item.id
    item = db.findOne 'users', { id: item.id }
    expect(item).to.equal undefined

  it "should clear the database file", ->
    db.clear()