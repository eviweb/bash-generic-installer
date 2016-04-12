### CLI
The cli library provides helpers to facilitate the creation of installer scripts.
#### The option provider
An option provider is a function that will be evaluated during runtime. It has to provide an associative array named `options`.         
Keys correspond to options, while values are their corresponding global variables.
```bash
# Example taken from the cli library
default_option_provider()
{
    declare -A options=(
        [u]="UNINSTALL"
    )

    declare -p options
}
# given your command file is named: install.sh
# the u option will be handled when using your command with the -u flag like follows: ./install.sh -u
# this will set the value of a global variable name $UNINSTALL to 1
```
> **Notes:**    
> for now, only one char short flags are allowed

#### The usage function
This function should provide the help message to display when the `-h` flag is passed to the command call or an incorrect option is used.
```bash
# Example taken from the cli library
default_usage()
{
    echo "
    Usage:
        ./install.sh [OPTIONS] INSTALLDIR
    Options:        
        -u      uninstall files
        -h      display this message
    Install/uninstall files to/from INSTALLDIR
"
}
```

#### The API
* **handleOptions _"$option\_provider"_ _"$usage"_ _"$@"_**: handles the command line option during runtime.    
It will display the usage message and:
    - exit with the code value: `0` when the command line is called with the `-h` flag
    - exit with the code value: `1` when the command line is called with an incorrect flag
```bash
# Example
# given the default option provider described in the example above
handleOptions "default_option_provider" "default_usage" "$@"
# when options have been treated, the remaining command line arguments are available through the global variable $ARGS
remaining_args="$ARGS"
```

> **Important Notes:**    
> * Don't forget to pass the `$@` array as the second argument of the `handleOptions` call. It is necessary to get all the command line options.    
> * Use the `$ARGS` global variable to get remaining arguments because `$@` cannot be updated from outside of the `handleOptions` function.    
> * You don't need to:
>   * initialize option global variables, `handleOptions` will take care about this and will initialize them to `0`
>   * provide a `h` flag option to manage your help message, `handleOptions` adds this flag automatically    

* **default_usage**: returns a default help message
* **default_option_provider**: provides a default option array