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

# jqplot needs to be minified
shopt -s extglob
minify static/jqplot/jquery.jqplot js jqplot/src/jqplot.core.js \
    jqplot/src/jqplot.!(jqplot|core|sprintf|effects.*).js \
    jqplot/src/jsdate.js \
    jqplot/src/jqplot.{sprintf,effects.*}.js
shopt -u extglob

minify static/jqplot/jquery.jqplot css jqplot/src/jquery.jqplot.css
