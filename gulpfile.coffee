coffee = require 'gulp-coffee'
gulp   = require 'gulp'
gutil  = require 'gulp-util'
mocha  = require 'gulp-mocha'


gulp.task 'default', ['build']


gulp.task 'build', ->
  gulp.src './lib/**/*.coffee'
    .pipe(coffee())
    .pipe(gulp.dest('build/lib'))


  gulp.src './index.coffee'
    .pipe(coffee())
    .pipe(gulp.dest('build'))


gulp.task 'test', -> exitOnFinish runTests


runTests = (reporter='spec', bail=true) ->
  gulp.src './test/**/*.coffee', read: false
    .pipe(mocha(reporter: reporter))
    .on 'error', (e) -> gutil.log e.toString()


exitOnFinish = (func, args...) ->
  func(args...)
    .on 'error', -> process.exit 1
    .on 'end',   -> process.exit 0
