#!/bin/bash

#source gbash.sh || exit

#source "$RUNFILES/google3/tools/build_defs/license/examples/manifest/license_display.sh"
source "$0.runfiles/rules_license/examples/manifest/license_display.sh"
#source module google3/tools/build_defs/license/examples/manifest/license_display.sh

echo "I am a program that uses open source code."
display_licenses
