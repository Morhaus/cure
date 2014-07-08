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
  .define 'includes', (value, [items], callback) ->
    items = [items] unless (_.isArray items)
    for item in items
      unless (_.contains value, item)
        return callback yes

    callback null, value

  .define 'excludes', (value, [items], callback) ->
    items = [items] unless (_.isArray items)
    for item in items
      if (_.contains value, item)
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

  # Validation/Sanitization
  .define 'each', (value, [schema], callback) ->
    async.map value, schema.run, callback
