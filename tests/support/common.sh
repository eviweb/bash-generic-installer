#! /bin/bash
workingdir()
{
    echo "${ENVBUILDER_TEMPDIR}"
}

oneTimeSetUp()
{
    newTestDir
}

oneTimeTearDown()
{
    removeTestDir
}

hookExists()
{
    type -t "$1" &>/dev/null
}

runHook()
{
    if hookExists "$1"; then
        $1
    fi
}

setUp()
{    
    OLDPWD="$PWD"
    prepareTestEnvironment

    runHook "onSetUp"
}

tearDown()
{
    cd "$OLDPWD"

    runHook "onTearDown"
}
