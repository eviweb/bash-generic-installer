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

loadBootstrap()
{
    . "$(maindir)/bootstrap.sh"
}

unloadBootstrap()
{
    unset -f $(compgen -A function -X \!'BGI::*')
}

createIncluder()
{
    local includer=$(workingdir)/includer.sh

    cat << EOF > ${includer}
#! /bin/bash
. "$(maindir)/bootstrap.sh"
echo \$(BGI::projectdir)
EOF
    chmod +x ${includer}

    ${includer}
}

onSetUp()
{
    unloadBootstrap
}

################ Unit tests ################
testBootstrapInitializer()
{
    assertNull "BGI::init function should not be loaded" "$(type -t BGI::init)"
    loadBootstrap
    assertEquals "BGI::init function is loaded" "function" "$(type -t BGI::init)"
    assertTrue "Initialization is done" BGI::initialized
}

testBootstrapProvidesPathUtilities()
{
    loadBootstrap

    assertSame "BGI::maindir should provide the path of the bash generic installer main directory" "$(maindir)" "$(BGI::maindir)"
    assertSame "BGI::libdir should provide the path of the provided libraries" "$(srcdir)/lib" "$(BGI::libdir)"
    assertSame "BGI::installerdir should provide the path of the provided installers" "$(srcdir)/installers" "$(BGI::installerdir)"
}

testBootstrapProvidesProjectDir()
{
    assertSame "BGI::projectdir should provide the main directory of the project" "$(workingdir)" "$(createIncluder)"
}

testBootstrapLoadsShFilesFromDir()
{
    loadBootstrap

    BGI::load "$(fixturesdir)" >${FSTDOUT} 2>${FSTDERR}

    assertContains "$(cat ${FSTDOUT})" "dummy1"
    assertContains "$(cat ${FSTDOUT})" "dummy2"
    assertNotContains "$(cat ${FSTDOUT})" "dummy4"
}

testBootstrapLoaderDoesNotFailIfDirIsEmpty()
{
    loadBootstrap

    BGI::load "$(fixturesdir)/emptydir" >${FSTDOUT} 2>${FSTDERR}

    assertNull "No error is triggered" "$(cat ${FSTDERR})"
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
