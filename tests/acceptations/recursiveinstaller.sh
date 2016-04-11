#! /bin/bash
# recursive installer acceptations

# runners for common tests
BGI::runner::installRecursively()
{
    BGI::installer::installRecursively "$(dirname $1)" "$(dirname $2)"
}

BGI::runner::uninstallRecursively()
{
    BGI::installer::uninstallRecursively "$(dirname $1)"
}

# recursively install from a given directory
BGI::testCustomInstall::installRecursively::story01()
{
    story_description "recursively install from a given directory"

    local src="$(BGI::projectdir)"
    local target="$(workingdir)"
    local files=$(listFiles "${src}")
    BGI::installer::installRecursively "${src}" "${target}"

    for file in ${files[@]}; do
        local filename="${file/${src}\//}"

        assertInstalled "${target}/${filename}"
    done
}

# recursive install should warn about existing files, but continue to install the others
BGI::testCustomInstall::installRecursively::story02()
{
    story_description "recursive install should warn about existing files, but continue to install the others"

    local src="$(BGI::projectdir)"
    local target="$(workingdir)"
    local files=$(listFiles "${src}")
    touch "${target}/dummy4"
    BGI::installer::installRecursively "${src}" "${target}" >${FSTDOUT} 2>${FSTDERR}

    assertWarning
    assertContains "$(cat ${FSTDERR})" "dummy4"

    for file in ${files[@]}; do
        local filename="${file/${src}\//}"

        if [ "${filename}" != "dummy4" ]; then
            assertInstalled "${target}/${filename}"
        else
            assertNotInstalled "${target}/${filename}"
        fi
    done    
}

# recursively uninstall from a given directory
BGI::testCustomUninstall::uninstallRecursively::story01()
{
    story_description "recursively uninstall from a given directory"

    local src="$(BGI::projectdir)"
    local target="$(workingdir)"
    local files=$(listFiles "${src}")
    BGI::installer::installRecursively "${src}" "${target}"
    BGI::installer::uninstallRecursively "${target}"

    for file in ${files[@]}; do
        local filename="${file/${src}\//}"

        assertNotInstalled "${target}/${filename}"
    done
}

# recursively uninstall only project files
BGI::testCustomUninstall::uninstallRecursively::story02()
{
    story_description "recursively uninstall only project files"

    local src="$(BGI::projectdir)"
    local target="$(workingdir)"
    local files=$(listFiles "${src}")
    touch "${target}/dummy4"
    ln -s "${target}/dummy4" "${target}/dummy5"
    BGI::installer::installRecursively "${src}" "${target}" >${FSTDOUT} 2>${FSTDERR}
    BGI::installer::uninstallRecursively "${target}"

    for file in ${files[@]}; do
        local filename="${file/${src}\//}"

        if [ "${filename}" != "dummy4" ] && [ "${filename}" != "dummy5" ]; then
            assertNotInstalled "${target}/${filename}"
        else
            assertTrue "${target}/${filename} should exist" "[ -e ${target}/${filename} ]"
        fi
    done
}
