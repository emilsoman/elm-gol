var gulp = require('gulp');

// Setup a paths object to easily access paths
var paths = {
  elm: ['src/**/*.elm'],
  scss: ['css/**/*.scss']
};

// Compiles files and starts watching for changes
var watch = require('gulp-watch');
gulp.task('watch', function() {
  watch(paths.elm, function(){
    gulp.start('elm');
  });
  watch(paths.scss, function(){
    gulp.start('scss');
  });
});

// Task that compiles all files
gulp.task('compile', ['elm', 'scss']);

// Task to compile elm files
var elm  = require('gulp-elm');
var plumber = require('gulp-plumber');
gulp.task('elm', function() {
  gulp.src(paths.elm)
    .pipe(plumber())
    .pipe(elm.bundle('script.js'))
    .pipe(gulp.dest('dist/'));
});

// Task to compile Sass files in app/scss to www/stylesheets
var sass = require('gulp-sass');
gulp.task('scss', function () {
    gulp.src(paths.scss)
        .pipe(sass())
        .pipe(gulp.dest('dist'));
});

// Default task compiles, starts ionic server and watches files
gulp.task('default', ['watch']);
