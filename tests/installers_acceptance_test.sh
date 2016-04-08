#! /bin/bash

################ Utilities #################
# get the full name of this script
me()
{
    echo "$(readlink -f $BASH_SOURCE)"
}

# get the path of parent directory of this script
mydir()
{
    echo "$(dirname $(me))"
}

# get the path of the project main directory
maindir()
{
    local curdir="$(mydir)"

    while \
        [ ! -e "${curdir}/lib" ] && \
        [ ! -e "${curdir}/src" ] && \
        [ ! -e "${curdir}/tests" ] && \
        [ "${curdir}" != "/" ]; do

        curdir="$(dirname ${curdir})"
    done

    echo "${curdir}"
}

# get the path of the source directory
srcdir()
{
    echo "$(maindir)/src"
}

# get the path of the test directory
qatestdir()
{
    echo "$(maindir)/tests"
}

# get the path of the main lib directory
libdir()
{
    echo "$(maindir)/lib"
}

############## End Utilities ###############
. $(qatestdir)/testinit.sh

load "$(srcdir)/lib/*.sh"
load "$(srcdir)/installers/*.sh"
load "$(qatestdir)/acceptations/*.sh"

onSetUp()
{
    eval "BGI::projectdir() { echo \"$(fixturesdir)\"; }"
}

onTearDown()
{
    unset -f "BGI::projectdir"
}

getInstallers()
{
    declare -a installers=( $(compgen -A function -X \!'BGI::installer::install*') )
    declare -p installers
}

getUninstallers()
{
    declare -a uninstallers=( $(compgen -A function -X \!'BGI::installer::uninstall*') )
    declare -p uninstallers
}

getStories()
{
    local target="$1"
    local context="$2"
    local pattern="${target/installer/$context}::story*"
    
    declare -a stories=( $(compgen -A function -X \!"${pattern}") )
    declare -p stories
}

runStories()
{
    local target="$1"
    local context="$2"
    local stories
    eval "$(getStories ${target} ${context})"
    
    for story in ${stories[@]}; do
        story_title "${story}"

        prepareTestEnvironment
        ${story}
    done
}

################ Unit tests ################
testInstall()
{
    local installers
    eval "$(getInstallers)"
 
    for installer in ${installers[@]}; do
        acceptance_title "${installer}"

        runStories "${installer}" "${FUNCNAME}"
    done
}

testUninstall()
{
    local uninstallers
    eval "$(getUninstallers)"
 
    for uninstaller in ${uninstallers[@]}; do
        acceptance_title "${uninstaller}"

        runStories "${uninstaller}" "${FUNCNAME}"
    done
}

################ RUN shunit2 ################
findShunit2()
{
    local curdir=$(dirname $(readlink -f "$1"))
    while [ ! -e "${curdir}/lib/shunit2" ] && [ "${curdir}" != "/" ]; do
        curdir=$(dirname ${curdir})
    done

    if [ "${curdir}" == "/" ]; then
        echo "Error Shunit2 not found !" >&2
        exit 1
    fi

    echo "${curdir}/lib/shunit2"
}

exitOnError()
{
    echo "$2" >&2
    exit $1
}
#
path=$(findShunit2 "$BASH_SOURCE")
code=$?
if [ ${code} -ne 0 ]; then
    exitOnError ${code} "${path}"
fi
. "${path}"/source/2.1/src/shunit2
#
# version: 0.2.2
