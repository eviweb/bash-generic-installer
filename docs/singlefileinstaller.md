### Single file installer
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