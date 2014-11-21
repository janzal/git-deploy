gulp = require 'gulp'
gutil = require 'gulp-util'
coffee = require 'gulp-coffee'
del = require 'del'

gulp.task 'clean', (cb) ->
  del([
      './src/**/*.js',
      './**/*.map',
    ], cb);

gulp.task 'coffee', [ 'clean' ], () ->
  gulp.src('./src/**/*.coffee')
    .pipe coffee bare: true
    .pipe gulp.dest './src'

gulp.task 'default', [ 'coffee' ]

module.exports = gulp