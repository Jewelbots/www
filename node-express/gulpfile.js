var gulp = require('gulp');
var debug = require('gulp-debug');



var concat = require('gulp-concat');
var uglify = require('gulp-uglify');
var rename = require('gulp-rename');
var sass = require('gulp-ruby-sass');

gulp.task('scripts', function () {
  return gulp.src('src/js/*.js')
    .pipe(concat('main.js'))
    .pipe(rename({suffix: '.min'}))
    .pipe(uglify())
    .pipe(debug())
    .pipe(gulp.dest('dist/assets/scripts'))
});


gulp.task('sass', function () {
  return sass('./src/css/',{
      debugInfo : true,
      lineNumbers: true,
      style : 'compressed'
    })
    .pipe(rename({
      suffix: '.min'
    }))
    .pipe(gulp.dest('./dist/assets/css'))
});

gulp.task('default', ['scripts', 'sass']);

