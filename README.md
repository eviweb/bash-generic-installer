Bash Generic Installer
======================
This package aims to provide a generic way to install packages in a shell environment.    

Installation
------------
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
### Bootstrap
* **BGI::projectdir**: returns the main directory of your project
```bash
# Example
# get the project directory
maindir=$(BGI::projectdir)
```
* **BGI::load _"$path"_**: sources `*.sh` files from a given directory
```bash
# Example
# all *.sh files from /path/to/my/sh/files are sourced in the current script
BGI::load "/path/to/my/sh/files"
```

### Installers
#### Single file installer
* **BGI::installer::installSingleFile _"$srcfile"_ _"$targetlink"_**: creates a target link to a file of the current project
```bash
# Example
# create a link /my/link -> /my/project/file
BGI::installer::installSingleFile "/my/project/file" "/my/link"
```
* **BGI::installer::installSingleFileToDir _"$srcfile"_ _"$targetdir"_**: creates a link to a file of the current project in a target directory
```bash
# Example
# create a link to /my/project/file in /my/targetdir
BGI::installer::installSingleFileToDir "/my/project/file" "/my/targetdir"
# this results in the creation of the link /my/targetdir/file -> /my/project/file
```
* **BGI::installer::uninstallSingleFile _"$targetlink"_**: removes a target link only if the source file belongs to the project
```bash
# Example
# remove the link /my/link -> /my/project/file
BGI::installer::uninstallSingleFile "/my/link"
```

>**Notes:**    
>Please note that:
>* already existing files or links are preserved
>* missing directories in the path of a link are created
>* empty directories on the path of a removed link are also removed

License
-------
This project is licensed under the terms of the [MIT License](/LICENSE)
