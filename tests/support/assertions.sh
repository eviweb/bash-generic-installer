#! /bin/bash
# assert a file is correctly installed
assertInstalled()
{
    local expected="$1"
    local realfile="$(readlink -f ${expected})"

    assertTrue "${expected} exists" "[ -h ${expected} ]"
    assertTrue "The real file exists ${realfile}" "[ -e ${realfile} ]"
}

# assert a file is not installed
assertNotInstalled()
{
    local file="$1"

    assertFalse "${file} does not exist" "[ -h ${file} ]"
}

# assert an error message is warned
assertWarningMessage()
{
    local message="$1"

    assertNull "no message to standard output" "$(cat ${FSTDOUT})"
    assertSame "the expected message is displayed" "${message}" "$(cat ${FSTDERR})"
}

# assert a warning message
assertWarning()
{
    assertNull "no message to standard output" "$(cat ${FSTDOUT})"
    assertTrue "a warning message is displayed" "cat ${FSTDERR} | grep -oi warning"
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

# assert an exit code value
assertExitCode()
{
    local expected="$1"
    local actual="$2"

    assertEquals "exit code should be ${expected}" ${expected} ${actual}
}

# assert a failure code
assertFailure()
{
    assertNotEquals "exit code should be different from 0" 0 $1
}

# assert a success code
assertSuccess()
{
    assertEquals "exit code should be equal to 0" 0 $1
}