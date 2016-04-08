#! /bin/bash
# utilities library

# recursively list files of a given directory
listFiles()
{
    local directory="$1"
    
    ls -d $(find ${directory} -type f)
}

# recursively list links of a given directory
listLinks()
{
    local directory="$1"
    
    ls -d $(find ${directory} -type l)
}

# build a file name from its source name and its target directory
buildFilename()
{
    local srcfile="$1"
    local src="$2"
    local target="$3"

    echo "${target}${srcfile/${src}/}"
}
