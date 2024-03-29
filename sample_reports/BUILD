# BUILD file defining reference implementations for reporting tools
#
# Copyright 2023 Google LLC
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
"""Rules for making license declarations."""

package(
    default_applicable_licenses = ["//:license"],
    default_visibility = ["//visibility:public"],
)

licenses(["notice"])

filegroup(
    name = "standard_package",
    srcs = glob(["**"]),
)

# Do not create a bzl_library(). That would create a dependency loop back
# to bazel-skylib. We export the .bzl files to the documentation maker.
exports_files(
    glob([
        "*.bzl",
    ]),
    visibility = ["//doc_build:__pkg__"],
)
