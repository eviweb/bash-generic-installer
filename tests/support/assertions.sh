#! /bin/bash
# assert a file is correctly installed
assertInstalled()
{
    local expected="$1"
    local realfile="$(readlink -f ${expected})"

    assertTrue "${expected} exists" "[ -h ${expected} ]"
    assertTrue "The real file exists ${realfile}" "[ -e ${realfile} ]"
}

# assert a file installation failed with a given error message
assertFailedWithErrorMessage()
{
    local command="$1"
    local message="$2"

    assertFalse "installation should fail" "${command} > ${FSTDOUT} 2> ${FSTDERR}"
    assertNull "no message to standard output" "$(cat ${FSTDOUT})"
    assertSame "the expected message is displayed" "${message}" "$(cat ${FSTDERR})"
}

# assert a failure exit code and a given error message to be displayed
assertErrorCodeAndMessage()
{
    local exit_code="$1"
    local message="$2"

    assertFalse "expect failure exit code" ${exit_code}
    assertSame "the expected message is displayed" "${message}" "$(cat ${FSTDERR})"
}

# assert a string contains another one
assertContains()
{
    assertTrue "'$1' contains '$2'" "echo '$1' | grep -oe '$2'"
}

# assert a string does not contain another one
assertNotContains()
{
    assertFalse "'$1' does not contain '$2'" "echo '$1' | grep -oe '$2'"
}