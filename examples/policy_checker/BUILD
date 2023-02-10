# Example of automated license policy definitions.

load("@rules_license//examples/policy_checker:license_policy.bzl", "license_policy")
load("@rules_license//examples/policy_checker:license_policy_check.bzl", "license_policy_check")

package(default_package_metadata = ["//:license", "//:package_info"])

# license_policy rules generally appear in a central location per workspace. That
# should be access controlled by the policy team.

# A production service can use licenses with most conditions
license_policy(
    name = "production_service",
    conditions = [
        "notice",
        "restricted_if_statically_linked",
    ],
)

# A mobile application usually can not allow end-user replacable libraries.
# So LGPL code (which is restricted_if_statically_linked) can not be used.
license_policy(
    name = "mobile_application",
    conditions = [
        "notice",
    ],
)

license_policy(
    name = "special_allowlisted_app",
    # There could be a allowlist of targets here.
    conditions = [
        "notice",
        "allowlist:acme_corp_paid",
    ],
)

# Now we might build checks of critical applications against policies
#
# Questions to consider?
# - Your organization migth want to fold these kinds of checks into
#   wrapper macros around the rules which generate services and apps
# - You might want to distribute checks to rules alongside the products
# - Or, you might want to consolidate them in a single place where your
#   compliance team owns them, as this example does

license_policy_check(
    name = "check_server",
    policy = ":production_service",
    target = "//examples/src:my_server",
)


# This is marked manual, so bazel test ... does not fail. Try it yourself with
#   bazel build :check_violating_server
license_policy_check(
    name = "check_violating_server",
    policy = ":production_service",
    tags = [
        "manual",
    ],
    target = "//examples/src:my_violating_server",
)
