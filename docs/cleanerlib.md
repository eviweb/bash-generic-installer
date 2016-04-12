### Cleaner
The cleaner library provides helpers to perform a cleanup during uninstallation.
* **BGI::cleaner::cleanPath _"$currentdir"_**: removes empty directories from deeper to higher
```bash
# Example
# Given the following directory tree:
# /my/targetdir:
#   + subdir1:
#       + file1
#       + subdir2:
#           + subdir3:
BGI::cleaner::cleanPath "/my/targetdir/subdir1/subdir2/subdir3"
# this will result in the new directory tree:
# /my/targetdir:
#   + subdir1:
#       + file1
```
