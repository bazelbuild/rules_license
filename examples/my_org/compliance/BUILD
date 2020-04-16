# Example license policy definitions.

load("@rules_license//rules:license_policy.bzl", "license_policy")

package(default_visibility = ["//examples:__subpackages__"])

# license_policy rules generally appear in a central location per workspace. They
# are intermingled with normal target build rules
license_policy(
    name = "production_service",
    conditions = [
        "notice",
        "restricted_if_statically_linked",
    ],
)

license_policy(
    name = "mobile_application",
    conditions = [
        "notice",
    ],
)

license_policy(
    name = "special_whitelisted_app",
    # There could be a whitelist of targets here.
    conditions = [
        "notice",
        "whitelist:acme_corp_paid",
    ],
)
