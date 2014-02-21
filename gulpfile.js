require('coffee-script').register();

var gulp    = require('gulp'),
    coffee  = require('gulp-coffee'),
    mocha   = require('gulp-mocha');


gulp.task('build', function() {
  gulp.src('./lib/**/*.coffee')
    .pipe(coffee())
    .pipe(gulp.dest('build/lib'))

  gulp.src('./index.coffee')
    .pipe(coffee())
    .pipe(gulp.dest('build'))
});

gulp.task('test', function() {
  gulp.src('./test/**/*.coffee', {'read': false})
    .pipe(mocha({
      reporter: 'spec'
    }))
})

gulp.task('default', ['build']);
