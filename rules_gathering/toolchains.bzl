"""
This module contains the provider for a sbom_tools toolchain as well as a basic implementation
that invokes binaries directly with well known cli arguments.
"""

SbomToolsInfo = provider("Toolchain used to generate and maniputate SBOMs", fields = [
    "create_intermediate_sbom",
    "merge_intermediate_sboms", 
    "convert_intermediate_sbom_to_format"
])

def _create_intermediate_sbom_builder(bin):
    exe = bin[DefaultInfo].files_to_run.executable
    def create_intermediate_sbom(ctx, sbom_file, licenses_file = None):
        inputs = [licenses_file]
        outputs = [ctx.outputs.out]
        args = ctx.actions.args()
        args.add("--licenses_info", licenses_file.path)
        args.add("--out", sbom_file.path)
        ctx.actions.run(
            mnemonic = "CreateSBOM",
            progress_message = "Creating SBOM for %s" % ctx.label,
            inputs = inputs,
            outputs = outputs,
            executable = exe,
            arguments = [args],
        )

        return [
            DefaultInfo(files = depset(outputs)),
        ]
        
    return create_intermediate_sbom

def _sbom_tools_toolchain(ctx):
    return [
        platform_common.ToolchainInfo(
            sbom_tools_info = SbomToolsInfo(
                create_intermediate_sbom = _create_intermediate_sbom_builder(ctx.attr.create_intermediate_sbom_binary),
            )
        )
    ]

sbom_tools_toolchain = rule(
    _sbom_tools_toolchain,
    attrs = {
        "create_intermediate_sbom_binary": attr.label(
            executable = True,
            allow_files = True,
            cfg = "exec",
            providers = [DefaultInfo],
        ),
    }
)