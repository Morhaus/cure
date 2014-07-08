_ = require 'lodash'

AnySchema = require './any'

module.exports = class DateSchema extends AnySchema

DateSchema
  # Validation
  .define 'before', (value, [date], callback) ->
    if value.getTime() < date.getTime()
      callback null, value
    else
      callback yes

  .define 'after', (value, [date], callback) ->
    if value.getTime() > date.getTime()
      callback null, value
    else
      callback yes
