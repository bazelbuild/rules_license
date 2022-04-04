
load("@rules_license//rules:license_policy.bzl", "license_policy")

package(default_visibility = ["//visibility:public"])

# license_policy rules generally appear in a central location per workspace. They
# are intermingled with normal target build rules
license_policy(
    name = "production_service",
    conditions = [
        "notice",
    ],
)
