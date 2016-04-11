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

################ Unit tests ################
testHandleOptions()
{
    local cmd="$(workingdir)/clirun"
    buildCommand "${cmd}" "$(defaultCommandContent)\necho \$MYVAR_A:\$MYVAR_B"

    assertEquals "running command with '-a' flag results in 1:0" "1:0" "$(${cmd} -a)"
    assertEquals "running command with '-b' flag results in 0:1" "0:1" "$(${cmd} -b)"
    assertEquals "running command with '-a -b' flags results in 1:1" "1:1" "$(${cmd} -a -b)"
}

testUsageUsingHelpFlag()
{
    local cmd="$(workingdir)/clirun"
    local expected="usage message"
    local content=$(defaultCommandContent "${expected}")
    buildCommand "${cmd}" "${content}"

    ${cmd} -h >${FSTDOUT} 2>${FSTDERR}
    local exit_code=$?

    assertSuccess "${exit_code}"
    assertNull "No error message should be displayed" "$(cat ${FSTDERR})"
    assertSame "Usage message should be displayed to stdout" "${expected}" "$(cat ${FSTDOUT})"
}

testUsageIsDisplayedInCaseWrongOption()
{
    local cmd="$(workingdir)/clirun"
    local expected="usage message"
    local content=$(defaultCommandContent "${expected}")
    buildCommand "${cmd}" "${content}"

    ${cmd} -t >${FSTDOUT} 2>${FSTDERR}
    local exit_code=$?

    assertErrorCodeAndMessage "${exit_code}" "${expected}"
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
