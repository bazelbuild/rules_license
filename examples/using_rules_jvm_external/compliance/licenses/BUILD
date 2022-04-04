load("@rules_license//rules:license_kind.bzl", "license_kind")

package(default_visibility = ["//visibility:public"])

license_kind(
    name = "Apache-2.0",
    conditions = ['notice'],
    url = "https://spdx.org/licenses/Apache-2.0.html",
)

license_kind(
    name = "not_gdpr_compliant",
    conditions = ['!deploy_eu'],
)

# Unused but other example license_kinds
license_kind(
    name = "MIT",
    conditions = ['notice'],
    url = "https://spdx.org/licenses/MIT.html",
)

license_kind(
    name = "acme_paid_per_seat",
    conditions = ['allowlist:acme_paid_per_seat'],
)
