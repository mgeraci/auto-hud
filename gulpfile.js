var gulp = require("gulp");
var concat = require("gulp-concat");
var util = require("gulp-util");
var sass = require("gulp-ruby-sass");
var coffee = require("gulp-coffee");

var static = "./static/";
var cssDir = static + "css/";
var cssFile = cssDir + "app.sass";
var cssFiles = cssDir + "**/*.sass";

var jsDir = static + "js/";
var jsFile = jsDir + "app.coffee";
var jsFiles = jsDir + "**/*.coffee";

gulp.task("default", function() {
	gulp.watch(cssFiles, ["compileSass"]);
	gulp.watch(jsFiles, ["compileCoffee"]);
});

gulp.task("compileSass", function() {
	return sass(cssFile)
		.on('error', sass.logError)
		.pipe(gulp.dest(cssDir));
});

gulp.task("compileCoffee", function() {
	return gulp.src(jsFiles)
		.pipe(
			coffee({bare: true}).on('error', util.log)
		)
		.pipe(concat("build.js"))
		.pipe(gulp.dest(jsDir))
});
