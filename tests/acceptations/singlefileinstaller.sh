#! /bin/bash
# single file installer acceptations

# install single file
BGI::testInstall::installSingleFile::story01()
{
    story_description "install single file"

    local src="$(fixturesdir)/dummy1.sh"
    local expected="$(workingdir)/dummy1.sh"
    BGI::installer::installSingleFile "${src}" "${expected}"

    assertInstalled "${expected}"
}

# install single file to non existing path
BGI::testInstall::installSingleFile::story02()
{
    story_description "install single file to non existing path"
    
    local src="$(fixturesdir)/dummy1.sh"
    local expected="$(workingdir)/deep/path/dummy1.sh"
    BGI::installer::installSingleFile "${src}" "${expected}"

    assertInstalled "${expected}"
}

# installation is not destructive
BGI::testInstall::installSingleFile::story04()
{
    story_description "installation is not destructive"
    
    local src="$(fixturesdir)/dummy1.sh"
    local existing="$(workingdir)/dummy1.sh"
    touch ${existing}
    BGI::installer::installSingleFile "${src}" "${existing}" >${FSTDOUT} 2>${FSTDERR}

    assertWarning
    assertNotInstalled "${existing}"
}

# install single file in a given directory
BGI::testInstall::installSingleFileToDir::story01()
{
    story_description "install single file in a given directory"

    local src="$(fixturesdir)/dummy1.sh"
    local target="$(workingdir)"
    BGI::installer::installSingleFileToDir "${src}" "${target}"

    assertInstalled "${target}/dummy1.sh"
}

# uninstall single file
BGI::testUninstall::uninstallSingleFile::story01()
{
    story_description "uninstall single file"

    local src="$(fixturesdir)/dummy1.sh"
    local target="$(workingdir)/dummy1.sh"
    BGI::installer::installSingleFile "${src}" "${target}"
    BGI::installer::uninstallSingleFile "${target}"

    assertNotInstalled "${target}"
}

# uninstall only files from project
BGI::testUninstall::uninstallSingleFile::story02()
{
    story_description "uninstall only files from project"

    local src="$(fixturesdir)/dummy1.sh"
    local target="$(workingdir)/dummy1.sh"
    local fake="$(workingdir)/dummy2.sh"
    local fakelink="$(workingdir)/dummy3.sh"    
    touch ${fake}
    ln -s ${fake} ${fakelink}
    BGI::installer::installSingleFile "${src}" "${target}"
    BGI::installer::uninstallSingleFile "${target}"
    BGI::installer::uninstallSingleFile "${fakelink}"
    BGI::installer::uninstallSingleFile "${fake}"

    assertNotInstalled "${target}"
    assertTrue "${fake} must still exist" "[ -e ${fake} ]"
    assertTrue "${fakelink} must still exist" "[ -e ${fakelink} ]"
}

# remove parent directory of an uninstalled file if it remains empty
BGI::testUninstall::uninstallSingleFile::story03()
{
    story_description "remove parent directory of an uninstalled file if it remains empty"

    local src1="$(fixturesdir)/dummy1.sh"
    local removable1="$(workingdir)/subdir1/subdir2"
    local src2="$(fixturesdir)/dummy2.sh"
    local removable2="$(workingdir)/subdir3/subdir4"
    local removable3="$(workingdir)/subdir3"
    local notremovable="$(workingdir)/subdir1"
    mkdir -p "$(workingdir)/subdir1"
    touch "${notremovable}/dummy3.sh"
    BGI::installer::installSingleFile "${src1}" "${removable1}/dummy1.sh"
    BGI::installer::installSingleFile "${src2}" "${removable2}/dummy2.sh"
    BGI::installer::uninstallSingleFile "${removable1}/dummy1.sh"
    BGI::installer::uninstallSingleFile "${removable2}/dummy2.sh"

    assertNotInstalled "${removable1}"
    assertNotInstalled "${removable2}"
    assertFalse "${removable1} should be removed" "[ -e ${removable1} ]"
    assertFalse "${removable2} should be removed" "[ -e ${removable2} ]"
    assertFalse "${removable3} should be removed" "[ -e ${removable3} ]"
    assertTrue "${notremovable} must still exist" "[ -e ${notremovable} ]"
}