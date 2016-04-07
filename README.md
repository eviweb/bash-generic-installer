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

License
-------
This project is licensed under the terms of the [MIT License](/LICENSE)
