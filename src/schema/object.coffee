_ = require 'lodash'
async = require 'async'

Node = require '../node'
AnySchema = require './any'

class ObjectSchema extends AnySchema

ObjectSchema
  # Validation/Sanitization
  .action 'format', (object) ->
    errors = []

    dirty = new Node().setup @value
    clean = new Node().setup {}

    async.eachSeries (_.keys object), (key, nextKey) =>
      schema = object[key]
      dirtyNodes = dirty.resolve [key]

      async.eachSeries dirtyNodes, (dirtyNode, nextNode) ->
        schema.validate dirtyNode.value, (err, newValue) ->
          if err
            errors.push { path: dirtyNode.path, error: err, type: schema.constructor.name }
          else
            clean.make dirtyNode.path, newValue
          nextNode()
      , nextKey
    , =>
      if errors.length > 0
        @fail errors
      else
        @next clean.build()

module.exports = ObjectSchema
