_ = require 'lodash'
async = require 'async'

AnySchema = require './any'

module.exports = class ArraySchema extends AnySchema

StringSchema = require './string'

ArraySchema
  # Sanitization
  .define 'slice', (value, args, callback) ->
    callback null, (value.slice args...)

  .define 'join', StringSchema, (value, args, callback) ->
    callback null, (value.join args...)

  # Validation
  .define 'includes', (value, [items, err], callback) ->
    items = [items] unless (_.isArray items)
    for item in items
      unless (_.contains value, item)
        return callback (err or 'includes'), value

    callback null, value

  .define 'excludes', (value, [items, err], callback) ->
    items = [items] unless (_.isArray items)
    for item in items
      if (_.contains value, item)
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

  # Validation/Sanitization
  .define 'each', (value, [schema], callback) ->
    async.map value, schema.run, callback
