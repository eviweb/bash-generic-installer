#! /bin/bash
# linker library

# create a link
BGI::linker::createLink()
{
    local src="$1"
    local target="$2"
    local exitcode=1

    if BGI::guards::ensureExists "${src}" && 
        BGI::guards::ensureNotExists "${target}"; then

      BGI::guards::ensureParents "${target}"
      ln -s "${src}" "${target}"
      exitcode=0
    fi

    return ${exitcode}
}

# remove a link
BGI::linker::removeLink()
{
    local target="$1"
    local exitcode=1

    if BGI::guards::ensureExists "${target}"; then
        unlink "${target}"
        exitcode=0
    fi

    return ${exitcode}
}
