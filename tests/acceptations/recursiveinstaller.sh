#! /bin/bash
# recursive installer acceptations

# recursively install from a given directory
BGI::testInstall::installRecursively::story01()
{
    story_description "recursively install from a given directory"

    local src="$(fixturesdir)"
    local target="$(workingdir)"
    local files=$(listFiles "${src}")
    BGI::installer::installRecursively "${src}" "${target}"

    for file in ${files[@]}; do
        local filename="${file/${src}\//}"

        assertInstalled "${target}/${filename}"
    done
}

# recursive install should warn about existing files, but continue to install the others
BGI::testInstall::installRecursively::story02()
{
    story_description "recursive install should warn about existing files, but continue to install the others"

    local src="$(fixturesdir)"
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
BGI::testUninstall::uninstallRecursively::story01()
{
    story_description "recursively uninstall from a given directory"

    local src="$(fixturesdir)"
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
BGI::testUninstall::uninstallRecursively::story02()
{
    story_description "recursively uninstall only project files"

    local src="$(fixturesdir)"
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

# recursively uninstall cleans up empty directories
BGI::testUninstall::uninstallRecursively::story03()
{
    story_description "recursively uninstall cleans up empty directories"

    local src="$(fixturesdir)"
    local target="$(workingdir)"
    local cleaned="${target}/subdir"
    BGI::installer::installRecursively "${src}" "${target}" >${FSTDOUT} 2>${FSTDERR}
    BGI::installer::uninstallRecursively "${target}"

    assertFalse "${cleaned} should be removed" "[ -e ${cleaned} ]"
}
