var gulp = require('gulp');
var debug = require('gulp-debug');
var fs = require('fs');
var handlebars = require('gulp-compile-handlebars');
var rename = require('gulp-rename');

var concat = require('gulp-concat');
var uglify = require('gulp-uglify');

var sass = require('gulp-ruby-sass');
var rev = require('gulp-rev');

var handlebarOpts = {
  helpers: {
    assetPath: function (path, context) {
      return ['dist/assets', context.data.root[path]].join('/');
    }
  }

};

gulp.task('compile', function () {
  //var manifest = JSON.parse(fs.readFileSync('dist/assets/manifest.json', 'utf8'));

  return gulp.src('src/html/*.hbs')
      .pipe(gulp.dest('dist'));
      //.pipe(handlebars(manifest, handlebarOpts))
      //.pipe(rename(function(path) {
      //  path.suffix = '';
      //  path.suffix += '.html';
      //}))


});

gulp.task('scripts', function () {
  return gulp.src('src/js/*.js')
    .pipe(uglify())
    .pipe(debug())
    .pipe(rev())
    .pipe(gulp.dest('dist/assets/scripts'))
    .pipe(rev.manifest({
      base: 'dist',
      merge: true
    }))
    .pipe(gulp.dest('dist'))
});


gulp.task('sass', function () {
  return sass('./src/scss/',{
      debugInfo : true,
      lineNumbers: true,
      style : 'compressed'
    })
    .pipe(rev())
    .pipe(gulp.dest('./dist/assets/css'))
    .pipe(rev.manifest({
      base: 'dist',
      merge: true
    }))
    .pipe(gulp.dest('dist'))
});

gulp.task('watch', function () {
  gulp.watch('src/js/*.js', ['scripts']);
  gulp.watch('src/scss/*.scss', ['sass']);
});

gulp.task('dev', ['scripts','sass', 'watch', 'compile']);
gulp.task('build', ['scripts','sass', 'compile']);
gulp.task('deploy', ['scripts','sass', 'compile']);


