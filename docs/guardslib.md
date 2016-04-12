### Guards
The guards library provides facilities to ensure some preconditions during installation or uninstallation processes.
* **BGI::guards::ensureExists _"$subject"_**: ensure a given subject (file, directory, link...) exists.    
It returns `0` in case the subject exists, `1` and displays a warning message if it doesn't.
```bash
# Example
if BGI::guards::ensureExists "/my/path"; do
    echo "We are sure /my/path exists"
else
    echo "We have been warned about non existing /my/path"
done
```
* **BGI::guards::ensureNotExists _"$subject"_**: ensure a given subject (file, directory, link...) doesn't exist.    
It returns `0` in case the subject doesn't exist, `1` and displays a warning message if it does.
```bash
# Example
if BGI::guards::ensureNotExists "/my/path"; do
    echo "We are sure /my/path doesn't exist"
else
    echo "We have been warned about existing /my/path"
done
```
* **BGI::guards::ensureParents _"$subject"_**: ensure parent directories of a given subject (file, directory, link...) exist.    
In case some of the parent directories don't exist the function will create them.
```bash
# Example
BGI::guards::ensureParents "/my/target/path/to/check"
# We are sure /my/target/path/to/check exists even if one or more of its parent directories didn't exist previously
```
* **BGI::guards::ensureRemovable _"$link"_**: ensure a symlink targets a file of the project, and then can be removed.    
It returns `0` if the link targets a file of the project or `1` if it doesn't.
```bash
# Example
if BGI::guards::ensureRemovable "/my/targetdir/link"; do
    echo "We are sure /my/targetdir/link targets a file of our project and can be removed"
else
    echo "This is not a file of our project"
done
```