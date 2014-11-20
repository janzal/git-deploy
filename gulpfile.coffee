gulp = require 'gulp'
gutil = require 'gulp-util'
coffee = require 'gulp-coffee'
del = require 'del'

gulp.task 'clean', (cb) ->
  del([
      './index.js',
      './src/**/*.js'
    ], cb);

gulp.task 'coffee', [ 'clean' ], () ->
  gulp.src('./src/**/*.coffee')
    .pipe coffee bare: true
    .on 'error', gutil.log
    .pipe gulp.dest './src'

  gulp.src('./index.coffee')
    .pipe coffee bare: true
    .on 'error', gutil.log
    .pipe gulp.dest ''

gulp.task 'default', [ 'coffee' ]