### Linker
The linker library provides function to manage symlinks.
* **BGI::linker::createLink _"$srcfile"_ _"$targetlink"_**: creates a symlink `$targetlink` that targets `$srcfile`.    
It returns `0` in case of success, or `1` in case of failure.
```bash
# Example
if BGI::linker::createLink "/my/project/file" "/my/targetdir/file"; do
    echo "/my/targetdir/file -> /my/project/file is created"
else
    echo "/my/targetdir/file has not been created"
done
```
* **BGI::linker::removeLink _"$targetlink"_**: removes a given symlink.    
It returns `0` in case of success, or `1` in case of failure.
```bash
# Example
if BGI::linker::removeLink "/my/targetdir/file"; do
    echo "/my/targetdir/file has been removed"
else
    echo "/my/targetdir/file has not been removed"
done
```