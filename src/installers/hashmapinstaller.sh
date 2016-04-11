#! /bin/bash
# hashmap installer

BGI::hashmap::placeholder()
{
    echo "\%TARGET\%"
}

BGI::hashmap::targetpath()
{
    local targetpath="$1"
    local replacement="$2"
    local placeholder="$(BGI::hashmap::placeholder)"

    if echo "${targetpath}" | grep -oe "${placeholder}" > /dev/null; then
        echo "${targetpath/${placeholder}/${replacement}}"
    else
        echo "${targetpath}/${replacement}"
    fi
}

BGI::installer::installFromMap()
{
    local map
    local provider="$1"
    eval $(${provider})

    for srcfile in "${!map[@]}"; do
        BGI::installer::installSingleFile "${srcfile}" "${map[$srcfile]}"
    done
}

BGI::installer::installFromFillerMap()
{
    local srcdir="$2"
    local targetpath="$3"
    local placeholder="$(BGI::hashmap::placeholder)"
    local map
    local provider="$1"
    eval $(${provider})

    for file in "${!map[@]}"; do
        srcfile="${srcdir}/${file}"
        target="$(BGI::hashmap::targetpath ${targetpath} ${map[$file]})/${file}"

        BGI::installer::installSingleFile "${srcfile}" "${target}"
    done
}

BGI::installer::uninstallFromMap()
{
    local map
    local provider="$1"
    eval $(${provider})

    for file in "${map[@]}"; do
        BGI::installer::uninstallSingleFile "${file}"
    done
}

BGI::installer::uninstallFromFillerMap()
{
    local targetpath="$2"
    local placeholder="$(BGI::hashmap::placeholder)"
    local map
    local provider="$1"
    eval $(${provider})

    for file in "${!map[@]}"; do
        target="$(BGI::hashmap::targetpath ${targetpath} ${map[$file]})/${file}"

        BGI::installer::uninstallSingleFile "${target}"
    done
}