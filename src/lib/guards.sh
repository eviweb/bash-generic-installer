#! /bin/bash
# guards library

# ensure a given subject exists or warn a message
BGI::guards::ensureExists()
{
    local subject="$1"
    local exitcode=0

    if [ ! -e "${subject}" ]; then
        BGI::io::warn "'${subject}' does not exist."
        exitcode=1
    fi

    return ${exitcode}
}

# ensure a given subject does not exist or warn a message
BGI::guards::ensureNotExists()
{
    local subject="$1"
    local exitcode=0

    if [ -e "${subject}" ]; then
        BGI::io::warn "'${subject}' already exists."
        exitcode=1
    fi

    return ${exitcode}
}

# ensure parent directories exist or create them
BGI::guards::ensureParents()
{
    local parent="${1%/*}"

    if [ ! -e "${parent}" ]; then
        mkdir -p "${parent}"
    fi
}