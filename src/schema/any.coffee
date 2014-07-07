_ = require 'lodash'

Schema = require './'

module.exports = class AnySchema extends Schema

# From https://github.com/lodash/lodash/issues/391
_is = (object, against) ->
  return false if object is undefined or object is null
  
  if (_.isArray against)
    for _against in against
      return true if (_is object, _against)
    return false
  else
    against = against::constructor.name if against.prototype
    type = Object::toString.call(object)[8...-1].toLowerCase()
    return type is against.toLowerCase()

NumberSchema = require './number'
StringSchema = require './string'
BooleanSchema = require './boolean'
ArraySchema = require './array'
DateSchema = require './date'
RegExpSchema = require './regexp'

AnySchema
  # Sanitization
  .define 'toNumber', NumberSchema, (value, callback)->
    callback null, (Number value)

  .define 'toString', StringSchema, (value, callback)->
    callback null, (String value)

  .define 'toBoolean', BooleanSchema, (value, callback)->
    callback null, (Boolean value)

  .define 'toArray', ArraySchema, (value, callback)->
    callback null, (Array::slice.call value)

  .define 'toDate', DateSchema, (value, callback)->
    callback null, (Date value)

  .define 'toRegExp', RegExpSchema, (value, callback)->
    callback null, (RegExp value)

  .define 'cast', (value, [type], callback) ->
    callback null, (type value)

  # Validation/Sanitization
  .define 'toJSON', StringSchema, (value, callback) ->
    try
      json = JSON.stringify value
      callback null, json
    catch e
      callback e, value

  # Validation
  .define 'in', (value, [array, err], callback) ->
    if (array.indexOf value) isnt -1
      callback null, value
    else
      callback (err or 'in'), value

  .define 'strictEquals', (value, [other, err], callback) ->
    if value is other
      callback null, value
    else
      callback (err or 'strictEquals'), value

  .define 'is', (value, [type, err], callback) ->
    if (_is value, type)
      callback null, value
    else
      callback (err or 'is'), value

  .define 'isnt', (value, [type, err], callback) ->
    unless (_is value, type)
      callback null, value
    else
      callback (err or 'isnt'), value

  .define 'gt', (value, [other, err], callback) ->
    if value > other
      callback null, value
    else
      callback (err or 'gt'), value

  .define 'gte', (value, [other, err], callback) ->
    if value >= other
      callback null, value
    else
      callback (err or 'gte'), value

  .define 'lt', (value, [other, err], callback) ->
    if value < other
      callback null, value
    else
      callback (err or 'lt'), value

  .define 'lte', (value, [other, err], callback) ->
    if value <= other
      callback null, value
    else
      callback (err or 'lte'), value

  .define 'action', (value, [fn], callback) ->
    fn value, callback

  # Mirror lodash
  .define 'equals', (value, [other, err], callback) ->
    if (_.isEqual value, other)
      callback null, value
    else
      callback (err or 'equals'), value

  .define 'empty', (value, [err], callback) ->
    if (_.isEmpty value)
      callback null, value
    else
      callback (err or 'empty'), value

  .define 'notEmpty', (value, [err], callback) ->
    unless (_.isEmpty value)
      callback null, value
    else
      callback (err or 'notEmpty'), value
