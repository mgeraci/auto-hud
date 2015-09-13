var gulp = require("gulp");
var gutil = require("gulp-util");
var sass = require("gulp-ruby-sass");
var coffee = require("gulp-coffee");

var static = "./static/";

gulp.task("default", function() {
	gulp.watch(static + "css/*.sass", ["compile-sass"]);
	gulp.watch(static + "js/*.coffee", ["compile-coffee"]);
});

gulp.task("compile-sass", function() {
	return sass(static + "css/app.sass")
		.on('error', sass.logError)
		.pipe(gulp.dest(static + "css/"));
});

gulp.task("compile-coffee", function() {
  gulp.src(static + "js/*.coffee")
    .pipe(coffee({bare: true})
		.on('error', gutil.log))
    .pipe(gulp.dest(static + "js/"));
});
