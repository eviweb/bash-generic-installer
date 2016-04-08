#! /bin/bash
# cleaner library

# remove empty directories from deeper to higher
BGI::cleaner::cleanPath()
{
    local current="$1"

    while [ -d "${current}" ] && [ -z "$(ls -A ${current})" ]; do
        rmdir "${current}"
        current="$(dirname ${current})"
    done
}
