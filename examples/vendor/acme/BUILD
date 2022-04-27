# A package with a commercial license.

load("@rules_license//rules:license.bzl", "license")

package(
    default_applicable_licenses = [":license"],
    default_visibility = ["//visibility:public"],
)

# The default license for an entire package is typically named "license".
license(
    name = "license",
    additional_info = {
        "homepage": "https://example.com",
    },
    license_kinds = [
        "@rules_license//examples/my_org/licenses:acme_corp_paid",
    ],
    license_text = "ACME_LICENSE",
)

cc_library(
    name = "acme",
    srcs = ["coyote.cc"],
)
