#!/bin/bash

function display_licenses {
  echo -n "Licenses: "
  cat "$(rlocation "rules_license/examples/manifest/licenses_manifest.txt")"
  echo
}
