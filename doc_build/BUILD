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
"""Generate the reference documentation.

How to:
   bazel build //doc_build:reference
   cp bazel-bin/doc_build/reference.md docs/latest.md
   git commit -m 'update docs' docs/latest.md
"""

load("@bazel_skylib//:bzl_library.bzl", "bzl_library")
load("@io_bazel_stardoc//stardoc:stardoc.bzl", "stardoc")
load("@rules_python//python:defs.bzl", "py_library")
load("//:version.bzl", "version")

package(default_package_metadata = ["//:license", "//:package_info"])

filegroup(
    name = "standard_package",
    srcs = [
        "BUILD",
    ] + glob([
        "*.bzl",
        "*.py",
    ]),
    visibility = ["//distro:__pkg__"],
)

exports_files(
    glob([
        "*.bzl",
    ]),
    visibility = [
        "//distro:__pkg__",
    ],
)

# pairs of rule name and the source file to get it from
# Must put macro wrapped rules after their wrapper
# buildifier: leave-alone, do not sort
ORDER = [
    ("license",         "//rules:license.bzl"),
    ("_license",        "//rules:license.bzl"),
    ("license_kind",    "//rules:license_kind.bzl"),
    ("_license_kind",   "//rules:license_kind.bzl"),
    ("package_info",    "//rules:package_info.bzl"),
    ("_package_info",   "//rules:package_info.bzl"),
    ("LicenseInfo",     "//rules:providers.bzl"),
    ("LicenseKindInfo", "//rules:providers.bzl"),
    ("PackageInfo",     "//rules:providers.bzl"),
]

genrule(
    name = "reference",
    srcs = ["%s.md" % rule for rule, _ in ORDER],
    outs = ["reference.md"],
    cmd = "$(location :merge) $(SRCS) >$@",
    tools = [":merge"],
)

[
    stardoc(
        name = "%s_gen" % rule,
        out = "%s.md" % rule,
        input = src,
        symbol_names = [
            rule,
        ],
        deps = [":lib_of_everything"],
    )
    for rule, src in ORDER
    if src
]

# gather all rules that should be documented
bzl_library(
    name = "lib_of_everything",
    srcs = [
        "//:version.bzl",
        "//rules:standard_package",
        "//rules/private:standard_package",
        # "@bazel_skylib//lib:paths",
    ],
    visibility = ["//visibility:public"],
)

# This is experimental. We are waiting for stardoc to get the features which
# are done in merge.
py_binary(
    name = "merge",
    srcs = ["merge.py"],
    python_version = "PY3",
    srcs_version = "PY3",
    visibility = ["//visibility:private"],
)
