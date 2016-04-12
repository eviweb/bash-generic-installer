Bash Generic Installer
======================
This package aims to provide a generic way to install packages in a shell environment.    

##### Health status
[![Travis CI - Build Status](https://travis-ci.org/eviweb/bash-generic-installer.svg)](https://travis-ci.org/eviweb/bash-generic-installer)
[![Github - Last tag](https://img.shields.io/github/tag/eviweb/bash-generic-installer.svg)](https://github.com/eviweb/bash-generic-installer/tags)

Installation
------------
### As Git submodule
From within your project directory, run:    
`git submodule add --name bash-generic-installer https://github.com/eviweb/bash-generic-installer lib/bash-generic-installer`    

Usage
-----
Source the boostrap file from `./lib/bash-generic-installer/bootstrap.sh`, then use the provided utilities.    
_ie. from the root of your project it could be something like this:_    
```bash
#! /bin/bash
. "$(dirname $(readlink -f $BASH_SOURCE))/lib/bash-generic-installer/bootstrap.sh"

#### Do your stuff ####
```

APIs
----
* [Bootstrap](/docs/bootstrap.md)
* Installers:
    - [Single file installer](/docs/singlefileinstaller.md)
    - [Recursive installer](/docs/recursiveinstaller.md)
    - [Hashmap installer](/docs/hashmapinstaller.md)

    > **Notes:**    
    > Please note that:
    >    - already existing files or links are preserved
    >    - missing directories in the path of a link are created
    >    - empty directories on the path of a removed link are also removed
* Libraries:
    - [Cleaner](/docs/cleanerlib.md)
    - [CLI](/docs/clilib.md)
    - [Guards](/docs/guardslib.md)
    - [IO](/docs/iolib.md)
    - [Linker](/docs/linkerlib.md)
    - [Utils](/docs/utilslib.md)

How to
------
### Create a simple installer
Consider this library is installed under `./lib/bash-generic-installer` and your project files lies under `./src`.    
Create a file `./install.sh` with the following content:
```bash
# Example using the recursive installer
# import bash generic installer
. $(dirname $(readlink -f $BASH_SOURCE))/lib/bash-generic-installer/bootstrap.sh

handleOptions "default_option_provider" "default_usage" "$@"

if ((${UNINSTALL})); then
    BGI::installer::uninstallRecursively "$ARGS"
else
    BGI::installer::installRecursively "$(BGI::projectdir)/src" "$ARGS"
fi
```
Make the installer executable: `chmod +x ./install.sh`.    
That's it.
```bash
# Examples of uses
# display the usage message
# the exit code is 0
./install.sh -h

# the exit code is 1 because z option is not handled
./install.sh -z

# install the directory tree under ./src to /my/targetdir
# assume /my/targetdir is empty, this will copy the directory tree structure and link all source files
./install.sh "/my/targetdir"

# uninstall files and clean up directories from /my/targetdir
./install.sh -u "/my/targetdir"
```

### Customize defaults
Starting from the example above modify the `./install.sh` content as follow:
```bash
# Example using the recursive installer
# import bash generic installer
. $(dirname $(readlink -f $BASH_SOURCE))/lib/bash-generic-installer/bootstrap.sh

custom_usage()
{
    echo "
    Usage:
        ./install.sh [OPTIONS] INSTALLDIR
    Options:
        -U      update files to new version
        -u      uninstall files
        -h      display this message
    Install/uninstall files to/from INSTALLDIR
"
}

custom_option_provider()
{
    declare -A options=(
        [u]="UNINSTALL"
        [U]="UPDATE"
    )

    declare -p options
}

handleOptions "custom_option_provider" "custom_usage" "$@"

if ((${UNINSTALL})); then
    BGI::installer::uninstallRecursively "$ARGS"
elif ((${UPDATE})); then
    # write code to perform update
else
    BGI::installer::installRecursively "$(BGI::projectdir)/src" "$ARGS"
fi
```

Contributing
------------
If you want to contribute please take a look at [Contributing](/CONTRIBUTING.md)

License
-------
This project is licensed under the terms of the [MIT License](/LICENSE)
