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

loadFile "$(srcdir)/lib/linker.sh"
loadFile "$(srcdir)/lib/io.sh"
loadFile "$(srcdir)/lib/guards.sh"

################ Unit tests ################
testLinkerCreateLink()
{
    local src="$(fixturesdir)/dummy1.sh"
    local target="$(workingdir)/dummy1.sh"

    BGI::linker::createLink "${src}" "${target}"
    local exitcode=$?

    assertSuccess ${exitcode}
    assertInstalled "${target}"
}

testLinkerCreateMissingTargetParentDirectory()
{
    local src="$(fixturesdir)/dummy1.sh"
    local target="$(workingdir)/subdir1/subdir2/dummy.sh"

    BGI::linker::createLink "${src}" "${target}"
    local exitcode=$?

    assertSuccess ${exitcode}
    assertInstalled "${target}"
}

testLinkerDoesNotCreateLinkAndWarnsIfSourceDoesNotExist()
{
    local src="Not/existing"
    local target="$(workingdir)/dummy1.sh"
    local errmsg="Warning: '${src}' does not exist."

    BGI::linker::createLink "${src}" "${target}" >${FSTDOUT} 2>${FSTDERR}
    local exitcode=$?

    assertFailure ${exitcode}
    assertWarningMessage "${errmsg}"
    assertNotInstalled "${target}"
}

testLinkerDoesNotCreateLinkAndWarnsIfTargetAlreadyExists()
{
    local src="$(fixturesdir)/dummy1.sh"
    local target="$(workingdir)/dummy1.sh"
    local errmsg="Warning: '${target}' already exists."

    touch "${target}"

    BGI::linker::createLink "${src}" "${target}" >${FSTDOUT} 2>${FSTDERR}
    local exitcode=$?

    assertFailure ${exitcode}
    assertWarningMessage "${errmsg}"
    assertNotInstalled "${target}"
}

testLinkerRemoveLink()
{
    local src="$(fixturesdir)/dummy1.sh"
    local target="$(workingdir)/dummy1.sh"

    BGI::linker::createLink "${src}" "${target}"
    BGI::linker::removeLink "${target}"
    local exitcode=$?

    assertSuccess ${exitcode}
    assertNotInstalled "${target}"
}

testLinkerWarnsIfLinkToRemoveDoesNotExist()
{
    local target="$(workingdir)/dummy1.sh"
    local errmsg="Warning: '${target}' does not exist."

    BGI::linker::removeLink "${target}" >${FSTDOUT} 2>${FSTDERR}
    local exitcode=$?

    assertFailure ${exitcode}
    assertWarningMessage "${errmsg}"
    assertNotInstalled "${target}"
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
