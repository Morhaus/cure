_ = require 'lodash'

Schema = require './'

module.exports = class AnySchema extends Schema

# From https://github.com/lodash/lodash/issues/391
_is = (object = @value, against = other) ->
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
  .action 'toNumber', NumberSchema, ->
    @next (Number @value)

  .action 'toString', StringSchema, ->
    @next (String @value)

  .action 'toBoolean', BooleanSchema, ->
    @next (Boolean @value)

  .action 'toArray', ArraySchema, ->
    @next (Array::slice.call @value)

  .action 'toDate', DateSchema, ->
    @next (Date @value)

  .action 'toRegExp', RegExpSchema, ->
    @next (RegExp @value)

  .action 'cast', (type) ->
    @next (type @value)

  .action 'toJSON', StringSchema, ->
    @next (JSON.stringify @value)

  # Validation
  .action 'in', (array) ->
    return @next() for value in array when (_.isEqual @value, value)
    @fail()

  .action 'strictIn', (array) ->
    if (_.indexOf array, @value) isnt -1 then @next() else @fail()

  .action 'equals', (value) ->
    if (_.isEqual @value, value) then @next() else @fail()

  .action 'strictEquals', (value) ->
    if @value is value then @next() else @fail()

  .action 'empty', ->
    if (_.isEmpty @value) then @next() else @fail()

  .action 'type', (type) ->
    if (_is @value, type)
      @next()
    else
      @fail()

  .action 'gt', (other) ->
    if @value > other
      @next()
    else
      @fail()

  .action 'gte', (other) ->
    if @value >= other
      @next()
    else
      @fail()

  .action 'lt', (other) ->
    if @value < other
      @next()
    else
      @fail()

  .action 'lte', (other) ->
    if @value <= other
      @next()
    else
      @fail()

  .action 'action', (fn) ->
    fn.call this
