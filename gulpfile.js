var gulp    = require('gulp'),
    mocha   = require('gulp-mocha')
    ts      = require('gulp-typescript');


gulp.task('build', function() {
  var src = './src/index.ts';
  src = './src/*.ts';
  var tsSource = gulp.src(src)
    .pipe(ts({
        noImplicityAny: true,
        out: 'index.js',
    }));
  return tsSource.js.pipe(gulp.dest('build'));
});

gulp.task('test', function() {
  require('typescript-require');
  gulp.src('./test/**/*.ts', {'read': false})
    .pipe(mocha({
      reporter: 'spec'
    }))
})

gulp.task('default', ['build']);
