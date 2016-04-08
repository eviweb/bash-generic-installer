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

License
-------
This project is licensed under the terms of the [MIT License](/LICENSE)
