#! /bin/bash
# command line library

handleOptions()
{
    local options
    local option_provider="$1"
    local usage="$2"
    shift 2
    eval $(${option_provider})

    local OPTIONS="${!options[@]}"
    OPTIONS=":h${OPTIONS/ /}"

    for var in "${options[@]}"; do
        eval "$var=0"
    done

    while getopts ${OPTIONS} option; do
        if [[ "${option}" == "h" ]]; then
            ${usage}
            exit 0
        elif [[ "${OPTIONS}" =~ "${option}" ]]; then
            eval "${options[${option}]}=1"
        else
            ${usage} >&2
            exit 1
        fi
    done
    shift $(($OPTIND - 1 ))

    ARGS="$@"
}

default_usage()
{
    echo "
    Usage:
        ./install.sh [OPTIONS] INSTALLDIR
    Options:        
        -u      uninstall files
        -h      display this message
    Install/uninstall files to/from INSTALLDIR
"
}

default_option_provider()
{
    declare -A options=(
        [u]="UNINSTALL"
    )

    declare -p options
}