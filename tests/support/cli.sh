buildCommand()
{
    local cmd="$1"
    local content="$2"

    echo -e "#! /bin/bash\n${content}" > ${cmd}
    chmod +x ${cmd}
}

defaultCommandContent()
{
    local usage_msg="$1"
    local usage="usage() { echo \"${usage_msg}\"; }"
    local options="option_provider() { declare -A options=([a]='MYVAR_A' [b]='MYVAR_B'); declare -p options; }"
    
    echo "
. $(srcdir)/lib/cli.sh
${usage}
${options}
handleOptions \"option_provider\" \"usage\" \$@
"
}