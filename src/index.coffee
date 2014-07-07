Schema = require './schema'

exports.any = new Schema.Any()

exports.object = new Schema.Object().is Object

exports.array = new Schema.Array().is Array

exports.string = new Schema.String().is String

exports.number = new Schema.Number().is Number

exports.boolean = new Schema.Boolean().is Boolean

exports.date = new Schema.Date().is Date

exports.regexp = new Schema.RegExp().is RegExp

exports.function = new Schema.Function().is Function

exports.Schema = Schema
