#! /bin/bash
# command line library

handleOptions()
{
    local options
    local option_provider="$1"
    shift
    eval $(${option_provider})

    local OPTS="${!options[@]}"
    OPTS=":h${OPTS/ /}"

    for var in "${options[@]}"; do
        eval "$var=0"
    done

    while getopts ${OPTS} option; do
        if [[ "${option}" == "h" ]]; then
            usage
            exit 0
        elif [[ "${OPTS}" =~ "${option}" ]]; then
            eval "${options[${option}]}=1"
        else
            usage >&2
            exit 1
        fi
    done
    shift $(($OPTIND - 1 ))
}
