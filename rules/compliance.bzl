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
"""License compliance checking."""

load(
    "@rules_license//rules:gather_licenses_info.bzl",
    "gather_licenses_info",
    "gather_licenses_info_and_write",
    "write_licenses_info",
)
load(
    "@rules_license//rules/private:gathering_providers.bzl",
    "TransitiveLicensesInfo",
)

# This rule is proof of concept, and may not represent the final
# form of a rule for compliance validation.
def _check_license_impl(ctx):
    # Gather all licenses and write information to one place

    licenses_file = ctx.actions.declare_file("_%s_licenses_info.json" % ctx.label.name)
    write_licenses_info(ctx, ctx.attr.deps, licenses_file)

    license_files = []
    if ctx.outputs.license_texts:
        license_files = get_licenses_mapping(ctx.attr.deps).keys()

    # Now run the checker on it
    inputs = [licenses_file]
    outputs = [ctx.outputs.report]
    args = ctx.actions.args()
    args.add("--licenses_info", licenses_file.path)
    args.add("--report", ctx.outputs.report.path)
    if ctx.attr.check_conditions:
        args.add("--check_conditions")
    if ctx.outputs.copyright_notices:
        args.add("--copyright_notices", ctx.outputs.copyright_notices.path)
        outputs.append(ctx.outputs.copyright_notices)
    if ctx.outputs.license_texts:
        args.add("--license_texts", ctx.outputs.license_texts.path)
        outputs.append(ctx.outputs.license_texts)
        inputs.extend(license_files)
    ctx.actions.run(
        mnemonic = "CheckLicenses",
        progress_message = "Checking license compliance for %s" % ctx.label,
        inputs = inputs,
        outputs = outputs,
        executable = ctx.executable._checker,
        arguments = [args],
    )
    outputs.append(licenses_file)  # also make the json file available.
    return [DefaultInfo(files = depset(outputs))]

_check_license = rule(
    implementation = _check_license_impl,
    attrs = {
        "deps": attr.label_list(
            aspects = [gather_licenses_info],
        ),
        "check_conditions": attr.bool(default = True, mandatory = False),
        "copyright_notices": attr.output(mandatory = False),
        "license_texts": attr.output(mandatory = False),
        "report": attr.output(mandatory = True),
        "_checker": attr.label(
            default = Label("@rules_license//tools:checker_demo"),
            executable = True,
            allow_files = True,
            cfg = "exec",
        ),
    },
)

# TODO(b/152546336): Update the check to take a pointer to a condition list.
def check_license(**kwargs):
    _check_license(**kwargs)

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

def _licenses_used_impl(ctx):
    # Gather all licenses and make it available as JSON
    write_licenses_info(ctx, ctx.attr.deps, ctx.outputs.out)
    return [DefaultInfo(files = depset([ctx.outputs.out]))]

_licenses_used = rule(
    implementation = _licenses_used_impl,
    doc = """Internal tmplementation method for licenses_used().""",
    attrs = {
        "deps": attr.label_list(
            doc = """List of targets to collect LicenseInfo for.""",
            aspects = [gather_licenses_info_and_write],
        ),
        "out": attr.output(
            doc = """Output file.""",
            mandatory = True,
        ),
    },
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

def licenses_used(name, deps, out = None, **kwargs):
    """Collects LicensedInfo providers for a set of targets and writes as JSON.

    The output is a single JSON array, with an entry for each license used.
    See gather_licenses_info.bzl:write_licenses_info() for a description of the schema.

    Args:
      name: The target.
      deps: A list of targets to get LicenseInfo for. The output is the union of
            the result, not a list of information for each dependency.
      out: The output file name. Default: <name>.json.
      **kwargs: Other args

    Usage:

      licenses_used(
          name = "license_info",
          deps = [":my_app"],
          out = "license_info.json",
      )
    """
    if not out:
        out = name + ".json"
    _licenses_used(name = name, deps = deps, out = out, **kwargs)
