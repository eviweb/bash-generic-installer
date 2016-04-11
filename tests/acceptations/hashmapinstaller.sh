#! /bin/bash
# hashmap installer acceptations

# runners for common tests
BGI::runner::installFromMap()
{
    eval "runner_map_provider() { declare -A map=([$1]=\"$2\"); declare -p map; }"

    BGI::installer::installFromMap "runner_map_provider"
}

BGI::runner::uninstallFromMap()
{
    eval "runner_map_provider() { declare -A map=([$1]=\"$1\"); declare -p map; }"

    BGI::installer::uninstallFromMap "runner_map_provider"
}

# map providers for custom tests
map_provider()
{
    declare -A map=(
        [$(BGI::projectdir)/dummy1.sh]="$(workingdir)/dummy1.sh"
        [$(BGI::projectdir)/subdir/dummy3.sh]="$(workingdir)/newdir/newdummy3.sh"
    )

    declare -p map
}

fillermap_provider()
{
    declare -A map=(
        [dummy1.sh]="newdir"
        [dummy2.sh]=""
        [subdir/dummy3.sh]="newdir2/subdir2"
    )

    declare -p map
}

# install from a given hashmap
BGI::testCustomInstall::installFromMap::story01()
{
    story_description "install from a given hashmap"

    BGI::installer::installFromMap "map_provider"

    assertInstalled "$(workingdir)/dummy1.sh"
    assertNotInstalled "$(workingdir)/dummy2.sh"
    assertInstalled "$(workingdir)/newdir/newdummy3.sh"
}

# install from a filler map
BGI::testCustomInstall::installFromFillerMap::story01()
{
    story_description "install from a filler map"

    local srcdir="$(BGI::projectdir)"
    local targetpath="$(workingdir)/maindir"
    BGI::installer::installFromFillerMap "fillermap_provider" "${srcdir}" "${targetpath}"

    assertInstalled "$(workingdir)/maindir/newdir/dummy1.sh"
    assertInstalled "$(workingdir)/maindir/dummy2.sh"
    assertInstalled "$(workingdir)/maindir/newdir2/subdir2/subdir/dummy3.sh"
}

# install from a filler map using the placeholder
BGI::testCustomInstall::installFromFillerMap::story02()
{
    story_description "install from a filler map using the placeholder"

    local srcdir="$(BGI::projectdir)"
    local targetpath="$(workingdir)/maindir/%TARGET%/subdir3"
    BGI::installer::installFromFillerMap "fillermap_provider" "${srcdir}" "${targetpath}"

    assertInstalled "$(workingdir)/maindir/newdir/subdir3/dummy1.sh"
    assertInstalled "$(workingdir)/maindir/subdir3/dummy2.sh"
    assertInstalled "$(workingdir)/maindir/newdir2/subdir2/subdir3/subdir/dummy3.sh"
}

# uninstall from a given hashmap
BGI::testCustomUninstall::uninstallFromMap::story01()
{
    story_description "uninstall from a given hashmap"
    touch "$(workingdir)/dummy2.sh"

    BGI::installer::installFromMap "map_provider"
    BGI::installer::uninstallFromMap "map_provider"

    assertNotInstalled "$(workingdir)/dummy1.sh"    
    assertNotInstalled "$(workingdir)/newdir/newdummy3.sh"
    assertTrue "$(workingdir)/dummy2.sh must still exist" "[ -e $(workingdir)/dummy2.sh ]"
}

# uninstall from a filler map
BGI::testCustomUninstall::uninstallFromFillerMap::story01()
{
    story_description "uninstall from a filler map"

    local srcdir="$(BGI::projectdir)"
    local targetpath="$(workingdir)/maindir"
    BGI::installer::installFromFillerMap "fillermap_provider" "${srcdir}" "${targetpath}"
    BGI::installer::uninstallFromFillerMap "fillermap_provider" "${targetpath}"

    assertNotInstalled "$(workingdir)/maindir/newdir/dummy1.sh"
    assertNotInstalled "$(workingdir)/maindir/dummy2.sh"
    assertNotInstalled "$(workingdir)/maindir/newdir2/subdir2/subdir/dummy3.sh"
}

# install from a filler map using the placeholder
BGI::testCustomUninstall::uninstallFromFillerMap::story02()
{
    story_description "uninstall from a filler map using the placeholder"

    local srcdir="$(BGI::projectdir)"
    local targetpath="$(workingdir)/maindir/%TARGET%/subdir3"
    BGI::installer::installFromFillerMap "fillermap_provider" "${srcdir}" "${targetpath}"
    BGI::installer::uninstallFromFillerMap "fillermap_provider" "${targetpath}"

    assertNotInstalled "$(workingdir)/maindir/newdir/subdir3/dummy1.sh"
    assertNotInstalled "$(workingdir)/maindir/subdir3/dummy2.sh"
    assertNotInstalled "$(workingdir)/maindir/newdir2/subdir2/subdir3/subdir/dummy3.sh"
}