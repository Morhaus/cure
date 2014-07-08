_ = require 'lodash'

AnySchema = require './any'

module.exports = class NumberSchema extends AnySchema

NumberSchema
  # Validation
  .define 'min', (value, [min], callback) ->
    if value >= min
      callback null, value
    else
      callback yes

  .define 'max', (value, [max], callback) ->
    if value <= max
      callback null, value
    else
      callback yes

  .define 'int', (value, callback) ->
    if value % 1 is 0
      callback null, value
    else
      callback yes
