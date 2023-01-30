# Copyright 2020 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

"""License compliance checking at analysis time."""

load(
    "@rules_license//examples/policy_checker:license_policy_provider.bzl",
    "LicensePolicyInfo",
)
load(
    "@rules_license//rules:gather_licenses_info.bzl",
    "gather_licenses_info",
)
load("@rules_license//rules:providers.bzl", "LicenseInfo")
load("@rules_license//rules_gathering:gathering_providers.bzl", "TransitiveLicensesInfo")

# This is a crude example of the kind of license reporting which can be done.
def _license_policy_check_impl(ctx):
    policy = ctx.attr.policy[LicensePolicyInfo]
    allowed_conditions = policy.conditions

    for target in ctx.attr.targets:
        if TransitiveLicensesInfo in target:
            for license in target[TransitiveLicensesInfo].licenses.to_list():
                for kind in license.license_kinds:
                    for condition in kind.conditions:
                        if condition not in allowed_conditions:
                            fail("Condition %s violates policy %s of %s" % (
                                condition,
                                policy.label,
                                target.label,
                            ))

    for target in ctx.attr.targets:
        if LicenseInfo in target:
            for license in target[LicenseInfo].licenses.to_list():
                for kind in license.license_kinds:
                    for condition in kind.conditions:
                        if condition not in allowed_conditions:
                            fail("Condition %s violates policy %s of %s" % (
                                condition,
                                policy.label,
                                target.label,
                            ))
    return [DefaultInfo()]

_license_policy_check = rule(
    implementation = _license_policy_check_impl,
    doc = """Internal implementation method for license_policy_check().""",
    attrs = {
        "policy": attr.label(
            doc = """Policy definition.""",
            mandatory = True,
            providers = [LicensePolicyInfo],
        ),
        "targets": attr.label_list(
            doc = """Target to collect LicenseInfo for.""",
            aspects = [gather_licenses_info],
            mandatory = True,
        ),
    },
)

def license_policy_check(name, targets, policy, **kwargs):
    """Checks a list of targets against a policy.

    Args:
      name: The target.
      targets: A list of targets to test for compliance with a policy
      policy: A rule providing LicensePolicyInfo.
      **kwargs: other args.

    Usage:

      license_policy_check(
          name = "license_info",
          targets = [":my_app"],
          policy = "//my_org/compliance/policies:mobile_application",
      )
    """
    _license_policy_check(name = name, targets = targets, policy = policy, **kwargs)
