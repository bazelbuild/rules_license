# Copyright 2022 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# A package with all code under a single license. This is the most common case
# we expect to see.

load("@rules_license//rules:license.bzl", "license")

# Using a package wide default ensure that all targets are associated with the
# license.
package(
    default_applicable_licenses = [":license"],
    default_visibility = ["//examples:__subpackages__"],
)

# The default license for an entire package is typically named "license".
license(
    name = "license",
    license_kinds = [
        "@rules_license//examples/my_org/licenses:generic_notice",
    ],
    license_text = "LICENSE",
)

cc_library(
    name = "libhhgttg",
    srcs = ["answer.cc"],
)
