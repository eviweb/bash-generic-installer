#! /bin/bash
# installer common acceptations

# install a single file to a given target
BGI::testInstall::common::story01()
{
    local runner="$1"
    story_description "install a single file to a given target, using: ${runner}"

    local src="$(BGI::projectdir)/dummy1.sh"
    local expected="$(workingdir)/dummy1.sh"

    ${runner} "${src}" "${expected}"
    assertInstalled "${expected}"
}

# install a single file to a non existing path creates missing directories
BGI::testInstall::common::story02()
{
    local runner="$1"
    story_description "install a single file to a non existing path creates missing directories, using: ${runner}"

    local src="$(BGI::projectdir)/dummy1.sh"
    local expected="$(workingdir)/a/non/exiting/path/dummy1.sh"

    ${runner} "${src}" "${expected}"
    assertInstalled "${expected}"
}

# an installation preserves exiting files and warns about
BGI::testInstall::common::story03()
{
    local runner="$1"
    story_description "an installation preserves exiting files and warns about, using: ${runner}"
    
    local src="$(BGI::projectdir)/dummy1.sh"
    local existing="$(workingdir)/dummy1.sh"
    touch ${existing}
    ${runner} "${src}" "${existing}" >${FSTDOUT} 2>${FSTDERR}

    assertWarning
    assertNotInstalled "${existing}"
}

# uninstall a single file from a given target
BGI::testUninstall::common::story01()
{
    local runner="$1"
    story_description "uninstall a single file from a given target, using: ${runner}"

    local installer="${runner/uninstall/install}"
    local src="$(BGI::projectdir)/dummy1.sh"
    local target="$(workingdir)/dummy1.sh"
    ${installer} "${src}" "${target}"
    ${runner} "${target}"

    assertNotInstalled "${target}"
}

# uninstall only files from project
BGI::testUninstall::common::story02()
{
    local runner="$1"
    story_description "uninstall only files from project, using: ${runner}"

    local installer="${runner/uninstall/install}"
    local src="$(BGI::projectdir)/dummy1.sh"
    local target="$(workingdir)/dummy1.sh"
    local fake="$(workingdir)/dummy2.sh"
    local fakelink="$(workingdir)/dummy3.sh"    
    touch ${fake}
    ln -s ${fake} ${fakelink}
    ${installer} "${src}" "${target}" >${FSTDOUT} 2>${FSTDERR}
    ${runner} "${target}"
    ${runner} "${fakelink}"
    ${runner} "${fake}"

    assertNotInstalled "${target}"
    assertTrue "${fake} must still exist" "[ -e ${fake} ]"
    assertTrue "${fakelink} must still exist" "[ -e ${fakelink} ]"
}

# remove parent directory of an uninstalled file if it remains empty
BGI::testUninstall::common::story03()
{
    local runner="$1"
    story_description "remove parent directory of an uninstalled file if it remains empty, using: ${runner}"

    local installer="${runner/uninstall/install}"
    local src1="$(BGI::projectdir)/dummy1.sh"
    local removable1="$(workingdir)/subdir1/subdir2"
    local src2="$(BGI::projectdir)/dummy2.sh"
    local removable2="$(workingdir)/subdir3/subdir4"
    local removable3="$(workingdir)/subdir3"
    local notremovable="$(workingdir)/subdir1"
    mkdir -p "$(workingdir)/subdir1"
    touch "${notremovable}/dummy3.sh"
    ${installer} "${src1}" "${removable1}/dummy1.sh"
    ${installer} "${src2}" "${removable2}/dummy2.sh"
    ${runner} "${removable1}/dummy1.sh"
    ${runner} "${removable2}/dummy2.sh"

    assertNotInstalled "${removable1}"
    assertNotInstalled "${removable2}"
    assertFalse "${removable1} should be removed" "[ -e ${removable1} ]"
    assertFalse "${removable2} should be removed" "[ -e ${removable2} ]"
    assertFalse "${removable3} should be removed" "[ -e ${removable3} ]"
    assertTrue "${notremovable} must still exist" "[ -e ${notremovable} ]"
}