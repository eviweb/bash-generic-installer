#! /bin/bash
# io library

# write a warning to stderr
BGI::io::warn()
{
    echo "Warning: $1" >&2
}
