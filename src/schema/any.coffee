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
  .define 'in', (value, [array], callback) ->
    if (array.indexOf value) isnt -1
      callback null, value
    else
      callback yes

  .define 'strictEquals', (value, [other], callback) ->
    if value is other
      callback null, value
    else
      callback yes

  .define 'is', (value, [type], callback) ->
    if (_is value, type)
      callback null, value
    else
      callback yes

  .define 'isnt', (value, [type], callback) ->
    unless (_is value, type)
      callback null, value
    else
      callback yes

  .define 'gt', (value, [other], callback) ->
    if value > other
      callback null, value
    else
      callback yes

  .define 'gte', (value, [other], callback) ->
    if value >= other
      callback null, value
    else
      callback yes

  .define 'lt', (value, [other], callback) ->
    if value < other
      callback null, value
    else
      callback yes

  .define 'lte', (value, [other], callback) ->
    if value <= other
      callback null, value
    else
      callback yes

  .define 'action', (value, [fn], callback) ->
    fn value, callback

  # Mirror lodash
  .define 'equals', (value, [other], callback) ->
    if (_.isEqual value, other)
      callback null, value
    else
      callback yes

  .define 'empty', (value, callback) ->
    if (_.isEmpty value)
      callback null, value
    else
      callback yes

  .define 'notEmpty', (value, callback) ->
    unless (_.isEmpty value)
      callback null, value
    else
      callback yes
