# Copyright 2020 Google LLC
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

"""Proof of concept. License restriction."""

load(
    "@rules_license//rules:providers.bzl",
    "LicenseInfo",
    "LicenseKindInfo",
    "LicensesInfo",
)

# An experiment to provide license defaults via a rule. This is far from
# working and should not be considered part of the current design.
#

def _default_licenses_impl(ctx):
    licenses = []
    for dep in ctx.attr.deps:
        if LicenseInfo in dep:
            licenses.append(dep[LicenseInfo])
    return [LicensesInfo(licenses = licenses)]

_default_licenses = rule(
    implementation = _default_licenses_impl,
    attrs = {
        "deps": attr.label_list(
            mandatory = True,
            doc = "Licenses",
            providers = [LicenseInfo],
            cfg = "host",
        ),
        "conditions": attr.string_list(
            doc = "",
        ),
    },
)

def default_licenses(licenses, conditions = None):
    _default_licenses(
        name = "__default_licenses",
        deps = ["%s_license" % l for l in licenses],
        conditions = conditions,
    )
