#!/bin/bash

function display_licenses {
  echo -n "Licenses: "
  cat "$0.runfiles/rules_license/examples/manifest/licenses_manifest.txt"
  echo
}
