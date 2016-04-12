# Contributing
Please feel free to clone [this repository](https://github.com/eviweb/bash-generic-installer) and submit pull requests.    
I would appreciate if you write tests for your code if it is not tested by existing ones. To facilitate your development process you may rely on the following tools:
* [Shunit2 Support](https://github.com/eviweb/shunit2-support)
* [Shell Testlib](https://github.com/eviweb/shell-testlib)
* [Shell QuickMock](https://github.com/eviweb/shell-quickmock)

## Directory Structure
* **src**: all APIs should be set under this directory
* **src/installers**: all installers should be put there
* **src/lib**: all helpers should be put there
* **tests**: all related test files lie under this directory
* **tests/acceptations**: put acceptance stories and runners under this directory
* **tests/fixtures**: hosts fixtures
* **tests/support**: libraries needed by tests
* **lib**: required modules
* **docs**: all documentation files

## Conventions
### Installers
* file names should respect the pattern `[ID]installer.sh` where ID is enough explicit to reveal the objective of the installer
* file should be set under `./src/installers`
* installation functions are defined under the namespace `BGI::installer`
* installation functions respect the pattern `install[ID]` where ID is enough explicit to reveal the objective of the function
* uninstallation functions respect the pattern `uninstall[ID]` where ID is enough explicit to reveal the objective of the function
* specific functions of an installer are set under the namespace `BGI::[ID]` where ID is the same as the one in of the installer file name

### Tests
* test file names should respect the pattern `[ID]_test.sh` where ID is enough explicit to reveal the objective of the tests
* test files should be set under `./src/tests`
* test files should have executable permissions

### Acceptance runners
* acceptance runners are defined in a file named as its related installer
* acceptance runner should be set under `./tests/acceptations`
* acceptance runner functions are defined under the namespace `BGI::runner`
* acceptance runner function name must be the same as the function it encapsulates

### Acceptance custom stories
* custom stories are defined in a file named as its related installer (the same as runners)
* custom story functions follow the naming pattern: [FUT]::story[XX] where FUT is the name of the function under test (without namespace) and XX is a two digits incremental number (start at 01)
* installation custom stories are defined under the namespace `BGI::testCustomInstall`
* uninstallation custom stories are defined under the namespace `BGI::testCustomUninstall`
* custom stories should use the `story_description` to display its purpose

## Acceptance tests
A certain number of default behaviours are expected for all installers. To ensure this homogeneity, some common acceptance tests are run against all these installers.
### Runners
To be able to run the common tests against a new installer, we need to encapsulate the installer function in what we call a _runner_.    
Each runner is called with two arguments:    
1. **_"$srcfile"_**: the source file to install _($1 in the following example)_   
2. **_"$targetlink"_**: the installed link _($2 in the following example)_
```bash
# Example taken from the Single file installer
# ./tests/acceptations/singlefileinstaller.sh
BGI::runner::installSingleFile()
{
    BGI::installer::installSingleFile "$1" "$2"
}
```
### Custom stories
Common scenarii are certainly not sufficient and it is possible to write custom stories to check specific behaviours.    
There are two types of custom stories:     
* `testCustomInstall`: for installation processes
* `testCustomUninstall`: for uninstallation processes
```bash
# Examples taken from the Hashmap installer
# ./tests/acceptations/hashmapinstaller.sh
map_provider()
{
    declare -A map=(
        [$(BGI::projectdir)/dummy1.sh]="$(workingdir)/dummy1.sh"
        [$(BGI::projectdir)/subdir/dummy3.sh]="$(workingdir)/newdir/newdummy3.sh"
    )

    declare -p map
}

# install story
BGI::testCustomInstall::installFromMap::story01()
{
    story_description "install from a given hashmap"

    BGI::installer::installFromMap "map_provider"

    assertInstalled "$(workingdir)/dummy1.sh"
    assertNotInstalled "$(workingdir)/dummy2.sh"
    assertInstalled "$(workingdir)/newdir/newdummy3.sh"
}

# uninstall story
BGI::testCustomUninstall::uninstallFromMap::story01()
{
    story_description "uninstall from a given hashmap"
    touch "$(workingdir)/dummy2.sh"

    BGI::installer::installFromMap "map_provider"
    BGI::installer::uninstallFromMap "map_provider"

    assertNotInstalled "$(workingdir)/dummy1.sh"    
    assertNotInstalled "$(workingdir)/newdir/newdummy3.sh"
    assertTrue "$(workingdir)/dummy2.sh must still exist" "[ -e $(workingdir)/dummy2.sh ]"
}
```
