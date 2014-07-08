_ = require 'lodash'
async = require 'async'

CureError = require '../error'
AnySchema = require './any'

class FormatError extends CureError
  constructor: (value, errors) ->
    @name = 'FormatError'
    @message = 'format'
    @value = value
    @errors = errors

class ObjectSchema extends AnySchema

ObjectSchema
  # Validation/Sanitization
  .define 'format', (value, [schemas], callback) ->
    errors = []
    formatted = {}

    async.eachSeries (_.keys schemas), (key, next) ->
      schemas[key].run value[key], (err, newValue) ->
        if err
          errors.push {key, error: err}
        else
          formatted[key] = newValue
        next()
    , ->
      if errors.length > 0
        callback (new FormatError value, errors), value
      else
        callback null, formatted

module.exports = ObjectSchema
