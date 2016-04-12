### Utils
The utils library provides some kind of utilities.
* **listFiles _"$directory"_**: recursively list files in a given directory
```bash
# Example
files=( $(listFiles "/my/directory") )
```
* **listLinks _"$directory"_**: recursively list symlinks in a given directory
```bash
# Example
links=( $(listLinks "/my/directory") )
```
* **buildFilename _"$srcfile"_ _"$srcdir"_ _"$targetdir"_**: build a file name from its source name and its target directory.
```bash
# Example
name="$(buildFilename /my/projectdir/subdir/file /my/projectdir /my/targetdir)"
echo "${name}"
# results in: /my/targetdir/subdir/file
```