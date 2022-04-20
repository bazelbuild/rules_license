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

workspace(name = "rules_license")

# You only need the dependencies if you intend to use any of the tools.
load("@rules_license//:deps.bzl", "rules_license_dependencies")

rules_license_dependencies()

### INTERNAL ONLY - lines after this are not included in the release packaging.

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

http_archive(
    name = "rules_pkg",
    sha256 = "62eeb544ff1ef41d786e329e1536c1d541bb9bcad27ae984d57f18f314018e66",
    urls = [
        "https://mirror.bazel.build/github.com/bazelbuild/rules_pkg/releases/download/0.6.0/rules_pkg-0.6.0.tar.gz",
        "https://github.com/bazelbuild/rules_pkg/releases/download/0.6.0/rules_pkg-0.6.0.tar.gz",
    ],
)

load("@rules_pkg//:deps.bzl", "rules_pkg_dependencies")

rules_pkg_dependencies()

### Experimental

local_repository(
    name = "rules_jvm_external",
    path = "../rules_jvm_external"
)

load("@rules_jvm_external//:defs.bzl", "maven_install")
# load("//examples/using_rules_jvm_external/compliance/licenses:defs.bzl", "lookup")

maven_install(
    artifacts = [
        "com.google.guava:guava:28.0-jre",
    ],
    repositories = [
        "https://jcenter.bintray.com/",
    ],
    # license_json = "//examples/using_rules_jvm_external/compliance/licenses:licenses.json"
)



