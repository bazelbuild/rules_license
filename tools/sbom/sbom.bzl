# Copyright 2023 The Bazel Authors. All rights reserved.
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
"""Generate an SBOM for a target."""

load(
    "//rules_gathering:gather_packages.bzl",
    "gather_package_info",
    "packages_used",
    "write_packages_info",
    "TransitivePackageInfo"
)

def _spdx_common(ctx, target, spdx_output, _gen_spdx_tool):
    # Gather all licenses and write information to one place
    name = "%s_info.json" % ctx.label.name
    aspect_output = ctx.actions.declare_file(name)

def _create_sbom(ctx, packages_used_file, spdx_output, _gen_spdx_tool):
    """Now turn the big blob of package data into something consumable.

    Might merge in rules_jvm and bzlmod lock files.
    """
    args = ctx.actions.args()
    inputs = [packages_used_file]
    outputs = [spdx_output]
    args.add("--packages_used", packages_used_file.path)
    args.add("--out", spdx_output.path)
    if hasattr(ctx.attr, "bzlmod_lock"):
        if ctx.attr.bzlmod_lock:
            args.add("--bzlmod_lock", ctx.file.bzlmod_lock.path)
            inputs.append(ctx.file.bzlmod_lock)
    if hasattr(ctx.attr, "maven_install"):
        if ctx.attr.maven_install:
            args.add("--maven_install", ctx.file.maven_install.path)
            inputs.append(ctx.file.maven_install)
    ctx.actions.run(
        mnemonic = "CreateSBOM",
        progress_message = "Creating SBOM for %s" % ctx.label,
        arguments = [args],
        inputs = inputs,
        outputs = outputs,
        executable = _gen_spdx_tool,
    )
    return [
        DefaultInfo(files = depset(outputs)),
        OutputGroupInfo(
            sbom_spdx = depset(outputs),
        ),
    ]

def _sbom_impl(ctx):
    print("TOAST1")
    _create_sbom(ctx, ctx.file.packages_used, ctx.outputs.out, ctx.executable._sbom_generator)

_sbom = rule(
    implementation = _sbom_impl,
    attrs = {
        "packages_used": attr.label(
            allow_single_file = True,
            mandatory = True,
        ),
        "out": attr.output(mandatory = True),
        "_sbom_generator": attr.label(
            default = Label("//tools/sbom:write_sbom_internal"),
            executable = True,
            allow_files = True,
            cfg = "exec",
        ),
        "bzlmod_lock": attr.label(
            mandatory = False,
            allow_single_file = True,
        ),
        "maven_install": attr.label(
            mandatory = False,
            allow_single_file = True,
        ),
    },
)

def sbom_spdx(
        name,
        target,
        out = None,
        bzlmod_lock = None,
        maven_install = "//:maven_install.json"):
    """Wrapper for sbom rule.

    Args:
        name: name
        target: Target to create sbom for
        out: output file name
        maven_install: maven lock file
    """
    packages = "_packages_" + name
    packages_used(
        name = packages,
        target = target,
        out = packages + ".json",
    )
    if not out:
        out = name + "_sbom.json"
    _sbom(
        name = name,
        out = out,
        packages_used = ":" + packages + ".json",
        bzlmod_lock = bzlmod_lock,
        maven_install = maven_install,
    )

def _gen_sbom_spdx_impl(target, ctx):
    print("TOAST")
    info_aspect_output = ctx.actions.declare_file("%s_info.json" % ctx.label.name)
    # traverse output from aspect and assemble it for writing...
    write_packages_info(
        ctx,
        top_level_target = target,
        transitive_package_info = target[TransitivePackageInfo],
        output = info_aspect_output,
    )
    spdx_output = ctx.actions.declare_file("%s.spdx.json" % ctx.label.name)
    print("WRITE TO", spdx_output.path)
    return _create_sbom(ctx, info_aspect_output, spdx_output, ctx.executable._gen_spdx)


gen_sbom_spdx = aspect(
    doc = """Generates an SPDX sbom for a target.""",
    implementation = _gen_sbom_spdx_impl,
    requires = [gather_package_info],
    attrs = {
        "_gen_spdx": attr.label(
            default = Label("//tools/sbom:write_sbom_internal"),
            allow_files = True,
            executable = True,
            cfg = "exec",
        ),
    },
)
