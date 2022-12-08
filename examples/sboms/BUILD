# Demonstrate the generate_sbom rule

load("@rules_license//rules:sbom.bzl", "generate_sbom")

# There are not a lot of targets in this rule set to build a SBOM from
# so we will (in a very self-referential way) generate one for the tool
# which generates the SBOMs
# See the output in bazel-bin/examples/sboms/write_sbom.txt
generate_sbom(
    name = "write_sbom_sbom",
    out = "write_sbom.txt",
    deps = ["//tools:write_sbom"],
)
