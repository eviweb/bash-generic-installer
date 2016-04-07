#! /bin/bash
# Bash Generic Installer Boostraper
# provides all base necessary features to work with this library
BGI::maindir()
{
    echo "$(dirname $(readlink -f $BASH_SOURCE))"
}

BGI::libdir()
{
    echo "$(dirname $(readlink -f $BASH_SOURCE))/src/lib"
}

BGI::installerdir()
{
    echo "$(dirname $(readlink -f $BASH_SOURCE))/src/installers"
}

BGI::load()
{
    local pattern="$1/*.sh"

    if ls ${pattern} &>/dev/null; then
        for file in ${pattern}; do
            . ${file}
        done
    fi
}

BGI::init()
{
    BGI::load "$(BGI::libdir)"
    BGI::load "$(BGI::installerdir)"

    eval "BGI::initialized() { return 0; }"
}

#
BGI::init