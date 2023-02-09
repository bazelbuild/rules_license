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
# An example of a code generator with a distinct license for the generated code.

load("@rules_license//rules:compliance.bzl", "licenses_used")
load("@rules_license//rules:license.bzl", "license")
load(":defs.bzl", "constant_gen")

package(
    default_applicable_licenses = [":license"],
    default_visibility = ["//examples:__subpackages__"],
)

# The default license for an entire package is typically named "license".
license(
    name = "license",
    package_name = "Trivial Code Generator",
    license_kinds = [
        "@rules_license//examples/my_org/licenses:generic_restricted",
    ],
    license_text = "LICENSE",
)

license(
    name = "license_for_emitted_code",
    package_name = "Trivial Code Generator Output",
    license_kinds = [
        "@rules_license//examples/my_org/licenses:unencumbered",
    ],
    license_text = "LICENSE.on_output",
)

# The generator itself will be licensed under :license
py_binary(
    name = "constant_generator",
    srcs = ["constant_generator.py"],
    python_version = "PY3",
)

# Sample: This target will be licensed under :license_for_emitted_code
constant_gen(
    name = "libhello",
    text = "Hello, world.",
    var = "hello_world",
)

# Verify the licenses are what we expect
licenses_used(
    name = "generator_licenses",
    out = "generator_licenses.json",
    deps = [":constant_generator"],
)

licenses_used(
    name = "generated_code_licenses",
    # Note: using default output file name
    deps = [":libhello"],
)

py_test(
    name = "verify_licenses_test",
    srcs = ["verify_licenses_test.py"],
    data = [
        ":generator_licenses.json",
        ":generated_code_licenses.json",
    ],
    python_version = "PY3",
    deps = [
        "//tests:license_test_utils",
    ],
)
