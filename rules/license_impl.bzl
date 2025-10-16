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
"""Rules for declaring the licenses used by a package.

"""

load(
    "@package_metadata//licenses/providers:license_kind_info.bzl",
    _newLicenseKindInfo = "LicenseKindInfo",
)
load(
    "@package_metadata//providers:package_attribute_info.bzl",
    "PackageAttributeInfo",
)
load(
    "@rules_license//rules:providers.bzl",
    "LicenseInfo",
    "LicenseKindInfo",
)

# Debugging verbosity
_VERBOSITY = 0

def _debug(loglevel, msg):
    if _VERBOSITY > loglevel:
        print(msg)  # buildifier: disable=print

#
# license()
#

def license_rule_impl(ctx):
    provider = LicenseInfo(
        license_kinds = tuple([k[LicenseKindInfo] for k in ctx.attr.license_kinds]),
        copyright_notice = ctx.attr.copyright_notice,
        package_name = ctx.attr.package_name or ctx.label.package,
        package_url = ctx.attr.package_url,
        package_version = ctx.attr.package_version,
        license_text = ctx.file.license_text,
        label = ctx.label,
    )
    _debug(0, provider)

    # Also return new style
    new_license_kinds = [k[_newLicenseKindInfo] for k in ctx.attr.license_kinds]
    if new_license_kinds:
        # This is a temporary hack. Just pick the first if there are multiple.
        # Package metadata should change to allow for more than one.
        kind = new_license_kinds[0]
    else:
        # This should not happen, because the override for license_kind should
        # always synthesize a new LicenseKindInfo
        kind = _newLicenseKindInfo(identifier = "<?>", name = "<?>")

    attribute = {
        "kind": {
            "identifier": kind.identifier,
            "name": kind.name,
        },
        "label": str(ctx.label),
    }
    files = []

    if ctx.attr.license_text:
        attribute["text"] = ctx.file.license_text.path
        files.append(ctx.attr.license_text[DefaultInfo].files)

    output = ctx.actions.declare_file("{}.package-attribute.json".format(ctx.attr.name))
    ctx.actions.write(
        output = output,
        content = json.encode(attribute),
    )

    return [
        DefaultInfo(
            files = depset(
                direct = [
                    output,
                ],
            ),
        ),
        provider,
        PackageAttributeInfo(
            kind = "build.bazel.attribute.license",
            attributes = output,
            files = files,
        ),
    ]
