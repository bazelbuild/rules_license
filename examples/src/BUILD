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
# Examples of applications and interactions with licenses

load("@rules_license//rules:compliance.bzl", "check_license", "licenses_used")
load("@rules_license//examples/vndor/constant_gen:defs.bzl", "constant_gen")

package(
    default_package_metadata = ["//:license", "//:package_info"],
    default_visibility = ["//examples:__subpackages__"],
)

cc_binary(
    name = "my_server",
    srcs = ["server.cc"],
    deps = [":message"],
)

# Sample
constant_gen(
    name = "message",
    text = "Hello, world.",
    var = "server_message",
)

# TODO(aiuto): Turn this strictly into a compliance test.
check_license(
    name = "check_server",
    check_conditions = False,
    license_texts = "server_licenses.txt",
    report = "server_report.txt",
    deps = [
        ":my_server",
    ],
)

#
# Verify the licenses are what we expect. The golden output shows that
# :my_server only uses the unencumbered license type.

licenses_used(
    name = "server_licenses",
    out = "server_licenses.json",
    deps = [":my_server"],
)

py_test(
    name = "server_licenses_test",
    srcs = ["server_licenses_test.py"],
    data = [":server_licenses.json"],
    python_version = "PY3",
    deps = [
        "@rules_license//tests:license_test_utils",
    ],
)

# This server uses something under a restricted license
cc_binary(
    name = "my_violating_server",
    srcs = ["server.cc"],
    deps = [
        ":message",
        "@rules_license//examples/vndor/acme",
        "@rules_license//examples/vndor/libhhgttg",
    ],
)
