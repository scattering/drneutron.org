#!/bin/bash

# Fetch/update from the git repositories to get to the lastest version
# of the dependent packages.  Each fetch pulls down missing resources, so
# as new dependencies are added they will be automatically updated.
#
# You may need to periodically empty repos/static as links change.
#
# Make sure the following programs are available:
#
#     git, hg, latex (for docs)
#
# Python should be running in a virtual environment with the following
# packages installed:
#
#     pip, setuptools
#     numpy, scipy, h5py
#     matplotlib (for gridding?)
#
# Update SECTION 1 with any new dependencies.  You may need to reset
# the virtual env, or explicitly pull new versions as dependencies change.
#
#


# === SECTION 1 ===
# dependency configuration

# installable dependencies
requires="setuptools numpy scipy h5py matplotlib"
installs="nose sphinx coverage rjsmin rcssmin"
djinstalls="userena apptemplates"

# === SECTION 2 ===
# library

prefix="=== "

# Update the git repo
# usage:  gitup  git@github.com:user package [revision]
#
# If the package is already checked out then update it, or if a revision is
# supplied, move it to the particular revision.  This doesn't handle branches.
# The package name should not end in .git
gitup ()
{
   url=$1; shift
   repo=$1; shift
   rev=$1; shift
   echo "${prefix}checking repo $repo"
   if test -d $repo; then
       if test -n $rev; then
           (cd $repo && git checkout $rev)
       else
           (cd $repo && git pull -q && git status -s)
       fi
   else
       git clone $url/$repo.git
       test -n $rev && git checkout $rev
   fi
}

# Update the hg repo
# usage:  gitup  https://bitbucket.org/user package [revision]
#
# If the package is already checked out then update it, or if a revision is
# supplied, move it to the particular revision.  This doesn't handle branches.
hgup ()
{
    url=$1; shift
    repo=$1; shift
    rev=$1; shift
    echo "${prefix}checking repo $repo"
    if test -d $repo; then
        if test -n $rev; then
            (cd $repo && hg checkout $rev && hg status)
        else
            (cd $repo && hg pull && hg update && hg status)
        fi
    else
        hg clone $url/$repo
        test -n $rev && hg checkout $rev
    fi
}

# Link from a repository into static resources
# usage: symlink source target
#
# Unlike "ln -s $source $target", symlink makes sure the target directory
# exists and the target does not.  May need to remove bad links.
#
symlink ()
{
    source=$1; shift
    target=$1; shift
    if ! test -a $target; then
        mkdir -p $(dirname $target)
        ln -sv $PWD/$source $target
    fi
}

# Check if a module is available in python
# usage: testpy module_name
#
# returns true if the module exists on the default python path, false otherwise.
testpy ()
{
    #echo ${prefix}look for $1
    python -c "import imp; imp.find_module(\"$1\")" 2>/dev/null
    return
}


# Check if django exists
# usage: check_django
#
# If it does not, it first asks that the user is in a virtual environment.
# We don't check if it is the _correct_ virtual environment on the assumption
# that virtual environments are easy to destroy and recreate.
check_django ()
{
    testpy django >/dev/null 2>&1 && return
    cat <<EOF
The django environment is not ready.  You should run django sites from a
virtual environment using only very few system packages.  This allows
different django applications to coexist on the same server without colliding.
Either conda or virtualenv environments will work.

Your environment should contain:

    pip numpy scipy h5py matplotlib

Any additional packages will be fetched using pip.
EOF
    read -p "${prefix}are you in the django virtual environment? " -n 1 -r
    echo
    if [[ ! $REPLAY =~ ^[Yy]$ ]]; then
        exit 1
    fi
    pip install django
}


# === SECTION 3 ===
# initialization: install python and initialize the repo directory

#set -x
# start in the repo directory
cd "$(dirname "$0")"

# Update python environment
for p in $requires; do ! testpy $p && echo "${prefix}missing $p" && exit 1; done
check_django
for p in $installs; do ! testpy $p && echo "${prefix}installing $p" && pip install $p; done
for p in $djinstalls; do ! testpy $p && echo "${prefix}installing $p" && pip install django-$p; done

# Update our own repo
echo "${prefix}checking repo $(grep url .git/config | sed -e's/^.*://;s/.git$//')"
git pull -q && git status -s

# Change to the package directory, making a new one if it doesn't exist
# Javascript packages will live in repos/static/js so that we can include
# repos/static in our static urls path.  Packages must symlink to get their
# resources in the right place.
mkdir -p repos
cd repos


# === SECTION 4 ===
# repository configuration
github=git@github.com
bitbucket=https://bitbucket.org

# Update all the repos
# jqplot is fixed to a particular revision, or tip for the most recent
hgup $bitbucket/cleonello jqplot 1250
gitup $github:scattering jqplot.science
gitup $github:scattering scattio
# gitup $github:scattering tracks
gitup $github:bumps bumps
# gitup $github:pkienzle periodictable

# Rebuild the repos with binary components
(cd bumps && python setup.py build_ext --inplace > /dev/null)

# jqplot: link resources to static/jqplot
# jqplot.science: link resources to static/jqplot/science
symlink jqplot/src/plugins static/jqplot/plugins
## Don't need to link the css since minify will do it for us
#symlink jqplot/src/jquery.jqplot.css static/jqplot
## The debug version lets you load individual jqplot files separately
symlink jqplot/src static/jqplot/debug
symlink jqplot.science static/jqplot/science

# Rebuild static resources
echo "${prefix}rebuilding static files"
../minify.sh

