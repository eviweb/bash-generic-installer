### Bootstrap
The bootstrap file is the entrypoint of the current library and provides some services that should be useful when creating an installer.
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