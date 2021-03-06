gulp = require 'gulp'
coffee = require 'gulp-coffee'
clean = require 'gulp-clean'

gulp.task 'clean', ->
  gulp
    .src 'lib/', read: false
    .pipe clean()

gulp.task 'default', ['clean'], ->
  gulp
    .src 'src/**/*.coffee'
    .pipe coffee
      bare: true
    .on 'error', (err) ->
      console.error err.stack, '\x07'
    .pipe (gulp.dest 'lib/')

gulp.task 'watch', ['default'], ->
  gulp.watch 'src/**/*.coffee', ['lib']