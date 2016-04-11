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

############### End Utilities ###############
. $(qatestdir)/testinit.sh
. $(srcdir)/lib/cli.sh
. $(srcdir)/lib/utils.sh

integration_installer()
{
    echo "
. $(maindir)/bootstrap.sh

usage()
{
    echo \"$(default_usage)\"
}

handleOptions \"default_option_provider\" \"\$@\"

if ((\${UNINSTALL})); then
    BGI::installer::uninstallRecursively \"\$ARGS\"
else
    BGI::installer::installRecursively \"\$(BGI::projectdir)/src\" \"\$ARGS\"
fi
"
}

buildInstaller()
{
    local cmd="$(workingdir)/projectdir/install.sh"
    echo "$(integration_installer)" > ${cmd}
    chmod +x ${cmd}
}

runInstaller()
{
    $(workingdir)/projectdir/install.sh $@
}

onSetUp()
{
    mkdir -p $(workingdir)/{targetdir,projectdir}
    cp -r "$(fixturesdir)" $(workingdir)/projectdir/src

    buildInstaller
}

################ Unit tests ################
testUsage()
{
    assertSame "Usage message is correct" "$(default_usage)" "$(runInstaller -h)"
}

testUsageOnWrongOption()
{
    runInstaller -t 2>${FSTDERR}

    assertSame "Usage message is correct" "$(default_usage)" "$(cat ${FSTDERR})"
}

testInstall()
{
    local srcdir="$(workingdir)/projectdir/src"
    local targetdir="$(workingdir)/targetdir"
    local files=$(listFiles "${srcdir}")

    runInstaller "${targetdir}"
    for file in ${files[@]}; do
        local targetfile=${file/${srcdir}/${targetdir}}

        assertInstalled "${targetfile}"
    done
}

testUninstall()
{
    local srcdir="$(workingdir)/projectdir/src"
    local targetdir="$(workingdir)/targetdir"
    local files=$(listFiles "${srcdir}")

    runInstaller "${targetdir}"
    runInstaller -u "${targetdir}"
    for file in ${files[@]}; do
        local targetfile=${file/${srcdir}/${targetdir}}

        assertNotInstalled "${targetfile}"
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
