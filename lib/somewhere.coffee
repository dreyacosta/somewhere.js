'use strict'

fs = require 'fs'

class Somewhere
  constructor: (databasePath) ->
    @databasePath = databasePath
    @database     = {}
    do @connect if @databasePath

  connect: ->
    if fs.existsSync @databasePath
      @database = JSON.parse fs.readFileSync @databasePath, 'utf-8'

  clear: ->
    fs.unlinkSync @databasePath if @databasePath
    @database = {}

  write: ->
    fs.writeFileSync @databasePath, JSON.stringify @database if @databasePath

  save: (collection, data) ->
    _checkCollection @database, collection
    data.id = do _uuid
    @database[collection].push data
    do @write
    _extend {}, data

  findOne: (collection, attrs) ->
    _checkCollection @database, collection
    return {} if !attrs
    _filterOne @database[collection], _matches attrs

  find: (collection, attrs) ->
    _checkCollection @database, collection
    return @database[collection] if !attrs
    _filter @database[collection], _matches attrs

  update: (collection, id, attrs) ->
    _checkCollection @database, collection
    data = item for item in @database[collection] when item.id is id
    data[key] = val for key, val of attrs if data
    do @write
    _extend {}, data

  remove: (collection, id) ->
    _checkCollection @database, collection
    index = @database[collection].indexOf(item) for item in @database[collection] when item.id is id
    return false if not index and index isnt 0
    @database[collection].splice index, 1 if index > -1
    do @write
    true

# -- Private methods -----------------------------------------------------------
_uuid = ->
  date = new Date().getTime()
  uuid = 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace /[xy]/g, (c) ->
    r = (date + Math.random() * 16) % 16 | 0
    date = Math.floor date/16
    v = if c is 'x' then r else r & 7 | 8
    v.toString 16

_checkCollection = (database, collection) ->
  return if database[collection]
  database[collection] = []

_filter = (obj, predicate) ->
  result = []
  result.push _extend({}, item) for item in obj when predicate item
  result

_filterOne = (obj, predicate) ->
  result = {}
  return _extend result, item for item in obj when predicate item
  result

_matches = (attrs) ->
  (obj) ->
    return false for key, val of attrs when attrs[key] isnt obj[key]
    true

_extend = (obj, args...) ->
  args.forEach (source) ->
    obj[method] = source[method] for method of source when hasOwnProperty.call source, method
  obj

module.exports = Somewhere