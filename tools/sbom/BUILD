# SBOM generator
load("@rules_python//python:defs.bzl", "py_binary")

package(
    default_package_metadata = ["//:license"],
    default_visibility = ["//visibility:public"],
)

filegroup(
    name = "srcs",
    srcs = glob(["**"]),
)

py_binary(
    name = "write_sbom_internal",
    srcs = ["write_sbom.py"],
    main = "write_sbom.py",
)
