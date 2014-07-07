_ = require 'lodash'

AnySchema = require './any'

module.exports = class DateSchema extends AnySchema

DateSchema
  # Validation
  .define 'before', (value, [date, err], callback) ->
    if value.getTime() < date.getTime()
      callback null, value
    else
      callback (err or 'before'), value

  .define 'after', (value, [date, err], callback) ->
    if value.getTime() > date.getTime()
      callback null, value
    else
      callback (err or 'after'), value
