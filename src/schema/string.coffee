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
  .define 'includes', (value, [strs, err], callback) ->
    strs = [strs] unless (_.isArray strs)
    for str in strs
      unless (_.contains value, str)
        return callback (err or 'includes'), value

    callback null, value

  .define 'excludes', (value, [strs, err], callback) ->
    strs = [strs] unless (_.isArray strs)
    for str in strs
      if (_.contains value, str)
        return callback (err or 'excludes'), value

    callback null, value

  .define 'minLen', (value, [min, err], callback) ->
    if value.length >= min
      callback null, value
    else
      callback (err or 'minLen'), value

  .define 'maxLen', (value, [max, err], callback) ->
    if value.length <= max
      callback null, value
    else
      callback (err or 'maxLen'), value

  .define 'len', (value, [len, err], callback) ->
    if value.length is len
      callback null, value
    else
      callback (err or 'len'), value

  .define 'email', (value, [err], callback) ->
    if (/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test value)
      callback null, value
    else
      callback (err or 'email'), value

  .define 'matches', (value, [regex, err], callback) ->
    if (regex.test value)
      callback null, value
    else
      callback (err or 'matches'), value
