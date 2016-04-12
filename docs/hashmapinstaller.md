### Hashmap installer
#### The map provider
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

#### The API
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
    )gs

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