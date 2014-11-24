gulp = require 'gulp'
gutil = require 'gulp-util'
coffee = require 'gulp-coffee'
mocha = require 'gulp-mocha'
del = require 'del'

require 'coffee-script/register'

gulp.task 'clean', (cb) ->
  del([
      './src/**/*.js',
      './**/*.map',
    ], cb);

gulp.task 'coffee', [ 'clean' ], () ->
  gulp.src('./src/**/*.coffee')
    .pipe coffee bare: true
    .pipe gulp.dest './src'

gulp.task 'test', () ->
  gulp
    .src './test/**/*.coffee', read: false
    .pipe mocha reporter: "spec"

gulp.task 'default', [ 'coffee' ]

module.exports = gulp