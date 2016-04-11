#! /bin/bash
# single file installer acceptations

# runners for common tests
BGI::runner::installSingleFile()
{
    BGI::installer::installSingleFile "$1" "$2"
}

BGI::runner::installSingleFileToDir()
{
    BGI::installer::installSingleFileToDir "$1" "$(dirname $2)"
}

BGI::runner::uninstallSingleFile()
{
    BGI::installer::uninstallSingleFile "$1"
}
