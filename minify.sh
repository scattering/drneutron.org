#!/bin/sh

# start in the root directory
cd "$(dirname "$0")"

minify ()
{
    target=$1; shift
    ext=$1; shift
    mkdir -p $(dirname $target)
    cat $* > $target.js
    python -mrjsmin $* <$target.js >$target.min.js
}

cd repos

# jqplot needs to be minified.  Using shopt extglob so that we can do a glob
# of all except pattern, and control the order of the files in the minified
# version.  Note that the jqplot
shopt -s extglob
minify static/jqplot/jquery.jqplot js jqplot/src/jqplot.core.js \
    jqplot/src/jqplot.!(core|sprintf|effects.*).js \
    jqplot/src/jsdate.js \
    jqplot/src/jqplot.{sprintf,effects.*}.js
shopt -u extglob

minify static/jqplot/jquery.jqplot css jqplot/src/jquery.jqplot.css
