# Copyright 2022 The Bazel Authors. All rights reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

load("//:version.bzl", "version")
load("@rules_pkg//pkg:pkg.bzl", "pkg_tar")
load("@rules_pkg//pkg/releasing:defs.bzl", "print_rel_notes")

package(
    default_visibility = ["//visibility:public"],
    default_applicable_licenses = ["//:license"],
)

licenses(["notice"])

alias(
    name = "distro",
    actual = "rules_license-%s" % version,
)

# Build the artifact to put on the github release page.
pkg_tar(
    name = "rules_license-%s" % version,
    srcs = [
        ":small_workspace",
        "//:standard_package",
        "//licenses/generic:standard_package",
        "//licenses/spdx:standard_package",
        "//rules:standard_package",
        "//rules/private:standard_package",
        "//tools:standard_package",
    ],
    extension = "tar.gz",
    # It is all source code, so make it read-only.
    mode = "0444",
    # Make it owned by root so it does not have the uid of the CI robot.
    owner = "0.0",
    package_dir = ".",
    strip_prefix = ".",
    tags = [
        "no_windows",
    ],
)

genrule(
    name = "small_workspace",
    srcs = ["//:WORKSPACE"],
    outs = ["WORKSPACE"],
    cmd = "sed -e '/### INTERNAL ONLY/,$$d' $(location //:WORKSPACE) >$@",
    tags = [
        "no_windows",
    ],
)

print_rel_notes(
    name = "relnotes",
    outs = ["relnotes.txt"],
    mirror_host = "mirror.bazel.build",
    org = "bazelbuild",
    repo = "rules_license",
    version = version,
)
