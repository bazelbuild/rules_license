# A sample library using new license rules.

load("@rules_license//rules:license.bzl", "license")

package(
    default_applicable_licenses = [":license"],
    default_visibility = [
        "//examples:__subpackages__",
        "//tests:__subpackages__",
    ],
)

# The default license for an entire package is typically named "license".
license(
    name = "license",
    package_name = "migrated package",
    license_kinds = ["//licenses/generic:restricted"],
    license_text = "LICENSE",
)

cc_library(
    name = "new_style_lib",
    srcs = [
        "new_style_lib.cc",
    ],
)
