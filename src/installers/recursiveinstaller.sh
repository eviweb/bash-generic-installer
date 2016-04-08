#! /bin/bash
# recursive installer

BGI::installer::installRecursively()
{
    local src="$1"
    local target="$2"
    local files=$(listFiles "${src}")

    for file in ${files[@]}; do
        local targetfile="$(buildFilename ${file} ${src} ${target})"

        BGI::installer::installSingleFile "${file}" "${targetfile}"
    done
}

BGI::installer::uninstallRecursively()
{
    local target="$1"
    local files=$(listLinks "${target}")

    for file in ${files[@]}; do
        BGI::installer::uninstallSingleFile "${file}"
    done
}
