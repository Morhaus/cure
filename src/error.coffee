class CureError extends Error
  constructor: (message, value) ->
    @name = 'CureError'
    @message = message
    @value = value

module.exports = CureError