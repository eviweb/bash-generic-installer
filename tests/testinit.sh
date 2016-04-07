#! /bin/bash
fixturesdir()
{
    echo "$(qatestdir)/fixtures"
}

supportdir()
{
    echo "$(qatestdir)/support"
}

. $(libdir)/shell-testlib/bootstrap.sh

use "envbuilder"
loadFile "$(supportdir)/common.sh"
