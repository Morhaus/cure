_ = require 'lodash'

AnySchema = require './any'

module.exports = class StringSchema extends AnySchema

ArraySchema = require './array'
ObjectSchema = require './object'

StringSchema
  # Sanitization
  .define 'split', ArraySchema, (value, args, callback) ->
    callback null, (value.split args...)

  .define 'append', (value, [str], callback) ->
    callback null, value + str

  .define 'prepend', (value, [str], callback) ->
    callback null, str + value

  .define 'surround', (value, [str], callback) ->
    callback null, str + value + str

  .define 'trim', (value, callback) ->
    if String::trim
      callback null, value.trim()
    else
      callback null, (value.replace /^\s+|\s+$/gm, '')

  .define 'uppercase', (value, callback) ->
    callback null, value.toUpperCase()

  .define 'lowercase', (value, callback) ->
    callback null, value.toLowerCase()

  .define 'parseJSON', ObjectSchema, (value, callback) ->
    callback null, (JSON.parse value)

  # Validation
  .define 'includes', (value, [strs], callback) ->
    strs = [strs] unless (_.isArray strs)
    for str in strs
      unless (_.contains value, str)
        return callback yes

    callback null, value

  .define 'excludes', (value, [strs], callback) ->
    strs = [strs] unless (_.isArray strs)
    for str in strs
      if (_.contains value, str)
        return callback yes

    callback null, value

  .define 'minLen', (value, [min], callback) ->
    if value.length >= min
      callback null, value
    else
      callback yes

  .define 'maxLen', (value, [max], callback) ->
    if value.length <= max
      callback null, value
    else
      callback yes

  .define 'len', (value, [len], callback) ->
    if value.length is len
      callback null, value
    else
      callback yes

  .define 'email', (value, callback) ->
    if (/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test value)
      callback null, value
    else
      callback yes

  .define 'matches', (value, [regex], callback) ->
    if (regex.test value)
      callback null, value
    else
      callback yes
