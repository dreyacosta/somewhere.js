"use strict"

gulp  = require 'gulp'
mocha = require 'gulp-mocha'

source =
  specs: 'specs/*.coffee'

gulp.task 'test', ->
  gulp.src source.specs
    .pipe mocha
      reporter: 'spec'
      require: 'coffee-script/register'

gulp.task 'default', ->
  gulp.watch source.specs, ['test']