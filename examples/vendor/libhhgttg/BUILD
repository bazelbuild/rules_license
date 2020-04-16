# A package with all code under a single license. This is the most common case
# we expect to see.

load("@rules_license//rules:license.bzl", "license")

# Using a package wide default ensure that all targets are associated with the
# license.
package(
    default_applicable_licenses = [":license"],
    default_visibility = ["//visibility:public"],
)

# The default license for an entire package is typically named "license".
license(
    name = "license",
    license_kinds = [
        "@rules_license//examples/my_org/licenses:generic_notice",
    ],
    license_text = "LICENSE",
)

cc_library(
    name = "libhhgttg",
    srcs = ["answer.cc"],
)
