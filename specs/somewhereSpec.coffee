'use strict'

expect = require('chai').expect
DB = require '../index'

describe "JSONdb module", ->
  describe "Memory and disk persistence", ->
    it "should set new database path", ->
      db = new DB './database.json'
      expect(db.databasePath).to.equal './database.json'

    it "should write first record on memory and persists on file", ->
      db = new DB './database.json'
      fruit =
        name: 'Apple'
        color: 'Green'
      db.save 'fruits', fruit
      expect(db.database.fruits.length).to.equal 1
      db = new DB './database.json'
      expect(db.database.fruits.length).to.equal 1

    it "should clear file database", ->
      db = new DB './database.json'
      results = db.find 'fruits'
      expect(results.length).to.equal 1
      do db.clear
      results = db.find 'fruits'
      expect(results.length).to.equal 0

    it "should only work on memory if path not provide", ->
      db = new DB()
      fruit =
        name: 'Apple'
        color: 'Green'
      db.save 'fruits', fruit
      expect(db.database.fruits.length).to.equal 1
      db = new DB()
      results = db.find 'fruits'
      expect(results.length).to.equal 0

  describe "findOne, find, update, remove, save if collection not exist", ->
    db = new DB()

    it "should return empty collection on findOne", ->
      item = db.findOne 'computers', brand: 'Apple'
      expect(db.database.computers.length).to.equal 0

    it "should return empty collection on find", ->
      item = db.find 'cars', brand: 'Ferrari'
      expect(db.database.cars.length).to.equal 0

    it "should return empty collection on update", ->
      item = db.update 'ebooks', brand: 'Kindle'
      expect(db.database.ebooks.length).to.equal 0

    it "should return empty collection on remove", ->
      item = db.remove 'electronic', brand: 'Philips'
      expect(db.database.electronic.length).to.equal 0

    it "should return a new collection with 1 element on save", ->
      item = db.save 'books', title: 'Testable JavaScript'
      expect(db.database.books.length).to.equal 1

  describe "Check findOne, find, update and remove methods", ->
    db = new DB './mochaTest.json'
    user =
      username: 'dreyacosta'
      name: 'David'
      blog: 'dreyacosta.com'
      source: 'twitter'
    item = db.save 'users', user

    it "should find one", ->
      item = db.findOne 'users', username: 'dreyacosta'
      expect(item.name).to.equal 'David'

    it "should find all", ->
      user =
        username: 'drey'
        name: 'David'
        blog: 'drey.com'
        source: 'twitter'
      item = db.save 'users', user
      items = db.find 'users', name: 'David'
      expect(items.length).to.equal 2

    it "should return an empty object if no match on find one", ->
      item = db.findOne 'users', name: 'Paul'
      expect(typeof item).to.equal 'object'
      expect(Object.keys(item).length).to.equal 0

    it "should return an empty array if no match on find all", ->
      items = db.find 'users', name: 'Paul'
      expect(items.push).to.be.a 'function'
      expect(items.length).to.equal 0

    it "should return a pure object when find one", ->
      item = db.findOne 'users', username: 'dreyacosta'
      expect(item.name).to.equal 'David'
      item.name = 'Mike'
      item = db.findOne 'users', username: 'dreyacosta'
      expect(item.name).to.equal 'David'

    it "should return a pure array when find all", ->
      user =
        username: 'pirish'
        name: 'Paul'
        blog: 'pirish.com'
        source: 'twitter'
      item = db.save 'users', user
      items = db.find 'users', source: 'twitter'
      expect(items.length).to.equal 3
      items[0].source = 'facebook'
      items = db.find 'users', source: 'twitter'
      expect(items.length).to.equal 3

    it "should return a pure object when update", ->
      item = db.findOne 'users', username: 'dreyacosta'
      item = db.update 'users', item.id, name: 'David Rey'
      expect(item.name).to.equal 'David Rey'
      item.name = 'Mike'
      item = db.findOne 'users', username: 'dreyacosta'
      expect(item.name).to.equal 'David Rey'

    it "should update item", ->
      data =
        country: 'Spain'
      item = db.findOne 'users', username: 'drey'
      item = db.update 'users', item.id, data
      expect(item.country).to.equal 'Spain'

    it "should not update an item that not exist and return empty object", ->
      item = db.update 'users', '12345', name: 'Brad'
      expect(typeof item).to.equal 'object'
      expect(Object.keys(item).length).to.equal 0

    it "should remove item from a collection", ->
      item = db.findOne 'users', username: 'drey'
      expect(item.username).to.equal 'drey'
      result = db.remove 'users', item.id
      expect(result).to.equal true
      item = db.findOne 'users', id: item.id
      expect(typeof item).to.equal 'object'
      expect(Object.keys(item).length).to.equal 0

    it "should remove first item from a collection", ->
      item = db.database.users[0]
      result = db.remove 'users', item.id
      expect(result).to.equal true

    it "should not remove an item that not exist", ->
      item = db.remove 'users', '12345'
      expect(item).to.equal false

    it "should clear the database file", ->
      do db.clear