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

#### Recursive installer
* **BGI::installer::installRecursively _"$srcdir"_ _"$targetdir"_**: recursively creates target links to each file from a given directory of the current project
```bash
# Example
# taken this project file structure:
# /my/project/filesdir:
#   + file1
#   + subdir:
#       + file2
#       + file3
BGI::installer::installRecursively "/my/project/filesdir" "/my/targetdir"
# this results in:
# /my/targetdir:
#   + file1 -> /my/project/filesdir/file1
#   + subdir:
#       + file2 -> /my/project/filesdir/subdir/file2
#       + file3 -> /my/project/filesdir/subdir/file3
```
* **BGI::installer::uninstallRecursively _"$targetdir"_**: recursively removes target links from a given directory only if the source files belong to the project
```bash
# Example
# recursively remove links under /my/targetdir
BGI::installer::uninstallRecursively "/my/targetdir"
```

#### Hashmap installer
##### The map provider
Hashmap functions expect a map provider as argument to get the required map.    
A map provider is a function that will be evaluated during runtime. It has to provide an associative array named `map`.    
Keys correspond to source paths, while values are target paths. ([More details in _The API_ section](#the-api))    
```bash
# Example
# a map provider
map_provider()
{
    declare -A map=(
        [srcfile]="target/path"
    )

    declare -p map
}
```

##### The API
* **BGI::installer::installFromMap _"$map\_provider"_**: creates target links to files using an hashmap that describes their relations

_Keys are expected to be full paths of source files, whereas values are expected to be full paths of related target links_
```bash
# Example
# a map provider
map_provider()
{
    declare -A map=(
        [/my/project/file1]="/my/targetdir/file1"
        [/my/project/file2]="/my/targetdir/subdir/file2"
    )

    declare -p map
}

# call the installer with the map provider function name
BGI::installer::installFromMap "map_provider"
```
* **BGI::installer::installFromFillerMap _"$map\_provider"_ _"$srcdir"_ _"$targetdir"_**: creates target links to files using an hashmap that describes their relations

_Keys are expected to be relative paths to `$srcdir` of source files, whereas values are expected to be a filler part of the path of related target links._
```bash
# Example
# a map provider
map_provider()
{
    declare -A map=(
        [file1]="newdir"
        [subdir/file2]="newdir"
        [file3]=""
    )

    declare -p map
}

# call the installer with the map provider function name
BGI::installer::installFromFillerMap "map_provider" "/my/project" "/my/targetdir"
# this results in:
# /my/targetdir:
#   + newdir:
#       + file1 -> /my/project/file1
#       + subdir:
#           + file2 -> /my/project/subdir/file2
#   + file3 -> /my/project/file3
```
_Using the placeholder `%TARGET%` in target path indicates we want values to replace this pattern instead of being appended to the target path_
```bash
# Example
# a map provider
map_provider()
{
    declare -A map=(
        [file1]="newdir"
        [subdir/file2]="newdir"
        [file3]=""
    )

    declare -p map
}

# call the installer with the map provider function name
BGI::installer::installFromFillerMap "map_provider" "/my/project" "/my/targetdir/%TARGET%/otherdir"
# this results in:
# /my/targetdir:
#   + newdir:
#       + otherdir:
#           + file1 -> /my/project/file1
#           + subdir:
#               + file2 -> /my/project/subdir/file2
#   + otherdir:
#       + file3 -> /my/project/file3
```
* **BGI::installer::uninstallFromMap _"$map\_provider"_**: removes target links to files using an hashmap that describes their relations. Links are removed only if their linked files belong to the project.

_Keys are expected to be full paths of source files, whereas values are expected to be full paths of related target links_
```bash
# Example
# a map provider
map_provider()
{
    declare -A map=(
        [/my/project/file1]="/my/targetdir/file1"
        [/my/project/file2]="/my/targetdir/subdir/file2"
    )

    declare -p map
}

# call the installer with the map provider function name
BGI::installer::uninstallFromMap "map_provider"
```
* **BGI::installer::uninstallFromFillerMap _"$map\_provider"_ _"$srcdir"_ _"$targetdir"_**: removes target links to files using an hashmap that describes their relations. Links are removed only if their linked files belong to the project.

_Keys are expected to be relative paths to `$srcdir` of source files, whereas values are expected to be a filler part of the path of related target links._
```bash
# Example
# a map provider
map_provider()
{
    declare -A map=(
        [file1]="newdir"
        [subdir/file2]="newdir"
        [file3]=""
    )

    declare -p map
}

# call the installer with the map provider function name
BGI::installer::uninstallFromFillerMap "map_provider" "/my/project" "/my/targetdir"
```
_Using the placeholder `%TARGET%` in target path indicates we want values to replace this pattern instead of being appended to the target path_
```bash
# Example
# a map provider
map_provider()
{
    declare -A map=(
        [file1]="newdir"
        [subdir/file2]="newdir"
        [file3]=""
    )

    declare -p map
}

# call the installer with the map provider function name
BGI::installer::uninstallFromFillerMap "map_provider" "/my/project" "/my/targetdir/%TARGET%/otherdir"
```

>**Notes:**    
>Please note that:
>* already existing files or links are preserved
>* missing directories in the path of a link are created
>* empty directories on the path of a removed link are also removed

License
-------
This project is licensed under the terms of the [MIT License](/LICENSE)
