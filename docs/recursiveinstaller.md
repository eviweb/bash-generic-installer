### Recursive installer
The recursive installer permits to install a whole directory tree to a target directory.    
The structure of the source tree is preserved in its destination.
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