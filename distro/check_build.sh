#!/bin/bash -ef
#
# This is a temporary hack to verify the distribution archive is sound.
#
# The intent is to create a rule which does this and add to
# rules_pkg. Comments within it are mostly for future me
# while writing that.

TARBALL=$(bazel build //distro:distro 2>&1 | grep 'rules_license-.*\.tar\.gz' | sed -e 's/ //g')
REPO_NAME='rules_license'

# This part can be standard from the rule


TARNAME=$(basename "$TARBALL")

TMP=$(mktemp -d) 
trap '/bin/rm -rf "$TMP"; exit 0' 0 1 2 3 15

cp "$TARBALL" "$TMP"

cd "$TMP"
cat >WORKSPACE <<INP
workspace(name = "test")

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

http_archive(
    name = "$REPO_NAME",
    urls = ["file:$TARNAME"],
)
INP

#
# The rest is specific to the package under test.
#

# You always need a BUILD, so that can be an attribute
cat >BUILD <<INP
load("@rules_license//rules:license.bzl", "license")

license(
   name = "license",
   license_kinds = ["@rules_license//licenses/generic:notice"],
   license_text = "LICENSE"
)
INP

# Need for a script to set up other files
# Or it folds into the tests cases?
echo license >LICENSE

# Then a list of commands to run. This can be a template
# too so we can substitute the path to bazel.
bazel build ...
bazel build @rules_license//rules/... 
bazel build @rules_license//licenses/...
bazel query @rules_license//licenses/generic/...
bazel query ...
