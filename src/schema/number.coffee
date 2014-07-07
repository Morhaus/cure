_ = require 'lodash'

AnySchema = require './any'

module.exports = class NumberSchema extends AnySchema

NumberSchema
  # Validation
  .define 'min', (value, [min, err], callback) ->
    if value >= min
      callback null, value
    else
      callback (err or 'min'), value

  .define 'max', (value, [max, err], callback) ->
    if value <= max
      callback null, value
    else
      callback (err or 'max'), value

  .define 'int', (value, [err], callback) ->
    if value % 1 is 0
      callback null, value
    else
      callback (err or 'int'), value
