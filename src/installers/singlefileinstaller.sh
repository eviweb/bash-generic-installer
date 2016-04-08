#! /bin/bash
# single file installer

BGI::installer::installSingleFile()
{
    local src="$1"
    local target="$2"

    BGI::linker::createLink "${src}" "${target}"
}

BGI::installer::installSingleFileToDir()
{
    local src="$1"
    local target="$2/${src##*/}"

    BGI::linker::createLink "${src}" "${target}"
}

BGI::installer::uninstallSingleFile()
{
    local target="$1"

    BGI::guards::ensureRemovable "$target" && 
        BGI::linker::removeLink "$target" &&
        BGI::cleaner::cleanPath "${target%/*}"
}
