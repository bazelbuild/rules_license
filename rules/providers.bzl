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
"""Providers for license rules."""

LicenseKindInfo = provider(
    doc = """Provides information about a license_kind instance.""",
    fields = {
        "conditions": "list(string): List of conditions to be met when using this packages under this license.",
        "label": "Label: The full path to the license kind definition.",
        "long_name": "string: Human readable license name",
        "name": "string: Canonical license name",
    },
)

LicenseInfo = provider(
    doc = """Provides information about a license instance.""",
    fields = {
        "copyright_notice": "string: Human readable short copyright notice",
        "label": "Label: label of the license rule",
        "license_kinds": "list(LicenseKindInfo): License kinds ",
        "license_text": "string: The license file path",
        "namespace": "string: namespace of the license rule",
        # TODO(aiuto): move to PackageInfo
        "package_name": "string: Human readable package name",
        "package_url": "URL from which this package was downloaded.",
        "package_version": "Human readable version string",
    },
)

LicensedTargetInfo = provider(
    doc = """Lists the licenses directly used by a single target.""",
    fields = {
        "target_under_license": "Label: The target label",
        "licenses": "list(label of a license rule)",
    },
)

# Constructor to reduce larger set of gathered data to what we want.
def TransitiveLicensesInfoInit(target_under_license=None, licenses=None, deps=None, traces=None, **kwargs):
    return {
        "target_under_license": target_under_license,
        "deps": deps,
        "licenses": licenses,
        "traces": traces,
    }


TransitiveLicensesInfo, _raw_TransitiveLicensesInfo = provider(
    doc = """The transitive set of licenses used by a target.""",
    fields = {
        "target_under_license": "Label: The top level target label.",
        "deps": "depset(LicensedTargetInfo): The transitive list of dependencies that have licenses.",
        "licenses": "depset(LicenseInfo)",
        "traces": "list(string) - diagnostic for tracing a dependency relationship to a target.",
    },
    init = TransitiveLicensesInfoInit,
)

# This is one way to do specify data
PackageInfo = provider(
    doc = """Provides information about a package.""",
    fields = {
        "type": "string: How to interpret data",
        "label": "Label: label of the package_info rule",
        "package_name": "string: Human readable package name",
        "package_url": "string: URL from which this package was downloaded.",
        "package_version": "string: Human readable version string",
    },
)

# This is more extensible. Because of the provider implementation, having a big
# dict of values rather than named fields is not much more costly.
# Design choice.  Replace data with actual providers, such as PackageInfo
MetadataInfo = provider(
    doc = """Generic bag of metadata.""",
    fields = {
        "type": "string: How to interpret data",
        "label": "Label: label of the metadata rule",
        "data": "String->any: Map of names to values",
    }
)

TransitiveMetadataInfo = provider(
    doc = """The transitive set of licenses used by a target.""",
    fields = {
        "top_level_target": "Label: The top level target label we are examining.",
        "other_metadata": "depset(MetatdataInfo)",
        "licenses": "depset(LicenseInfo)",
        "package_info": "depset(PackageInfo)",

        "target_under_license": "Label: A target which will be associated with some licenses.",
        "deps": "depset(LicensedTargetInfo): The transitive list of dependencies that have licenses.",
        "traces": "list(string) - diagnostic for tracing a dependency relationship to a target.",
    },
)
