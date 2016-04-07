#! /bin/bash
# linker utilities

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
