async = require 'async'
_ = require 'lodash'

module.exports = class Schema
  @action: (name, type, fn) ->
    unless fn
      fn = type
      type = null

    @::[name] = (args...) ->
      name = "not #{name}" if @_reversed
      actions = @actions[..]
      actions.push { name, fn, args, reversed: @_reversed }
      ctor = type or @constructor
      return (new ctor actions)

    return @

  constructor: (@actions = [], opts = {}) ->
    if opts.reverse
      @_reversed = true
      @not = opts.reverse
    else
      @_reversed = false
      @not = new @constructor @actions[..], reverse: @

    @_present = opts.present or 0

  validate: (value, callback) ->
    if not value?
      callback? (if @_present is 1 then 'present' else null), value
      return this

    if value? and @_present is -1
      callback? 'not present', value
      return this

    async.eachSeries @actions, (action, nextAction) ->
      context =
        value: value
        next: (newValue) ->
          value = newValue if newValue?
          nextAction()
        fail: (err) ->
          nextAction (err or action.name)
      [context.next, context.fail] = [context.fail, context.next] if action.reversed
      action.fn.apply context, action.args
    , (err) ->
      callback? err, value

    return this

  present: ->
    present = if @_reversed then -1 else 1
    return (new @constructor @actions[..], { present })

Schema.Any = require './any'
Schema.Object = require './object'
Schema.Array = require './array'
Schema.Number = require './number'
Schema.String = require './string'
Schema.Date = require './date'
Schema.Boolean = require './boolean'
Schema.RegExp = require './regexp'
Schema.Function = require './function'
