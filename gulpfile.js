var gulp    = require('gulp'),
    coffee  = require('gulp-coffee');
    concat  = require('gulp-concat');

gulp.task('build', function() {
  gulp.src('./lib/**/*.coffee')
    .pipe(coffee())
    .pipe(gulp.dest('build/lib'))

  gulp.src('./index.coffee')
    .pipe(coffee())
    .pipe(gulp.dest('build'))
});

gulp.task('default', ['build']);
