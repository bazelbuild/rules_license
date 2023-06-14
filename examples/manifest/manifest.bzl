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
"""An example using gather_licenses_info as input to another action."""

load(
    "@rules_license//rules:gather_licenses_info.bzl",
    "gather_licenses_info",
)
load(
    "@rules_license//rules_gathering:gathering_providers.bzl",
    "TransitiveLicensesInfo",
)

def get_licenses_mapping(deps, warn = False):
    """Creates list of entries representing all licenses for the deps.

    Args:

      deps: a list of deps which should have TransitiveLicensesInfo providers.
            This requires that you have run the gather_licenses_info
            aspect over them

      warn: boolean, if true, display output about legacy targets that need
            update

    Returns:
      {File:package_name}
    """
    tls = []
    for dep in deps:
        lds = dep[TransitiveLicensesInfo].licenses
        tls.append(lds)

    ds = depset(transitive = tls)

    # Ignore any legacy licenses that may be in the report
    mappings = {}
    for lic in ds.to_list():
        if type(lic.license_text) == "File":
            mappings[lic.license_text] = lic.package_name
        elif warn:
            print("Legacy license %s not included, rule needs updating" % lic.license_text)
    return mappings


def _manifest_impl(ctx):
    # Gather all licenses and make it available as deps for downstream rules
    # Additionally write the list of license filenames to a file that can
    # also be used as an input to downstream rules.
    licenses_file = ctx.actions.declare_file(ctx.attr.out.name)
    mappings = get_licenses_mapping(ctx.attr.deps, ctx.attr.warn_on_legacy_licenses)
    ctx.actions.write(
        output = licenses_file,
        content = "\n".join([",".join([f.path, p]) for (f, p) in mappings.items()]),
    )
    return [DefaultInfo(files = depset(mappings.keys()))]

_manifest = rule(
    implementation = _manifest_impl,
    doc = """Internal tmplementation method for manifest().""",
    attrs = {
        "deps": attr.label_list(
            doc = """List of targets to collect license files for.""",
            aspects = [gather_licenses_info],
        ),
        "out": attr.output(
            doc = """Output file.""",
            mandatory = True,
        ),
        "warn_on_legacy_licenses": attr.bool(default = False),
    },
)

def manifest(name, deps, out = None, **kwargs):
    if not out:
        out = name + ".manifest"
    _manifest(name = name, deps = deps, out = out, **kwargs)

