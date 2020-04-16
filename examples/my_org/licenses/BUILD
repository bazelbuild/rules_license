# Example license kind definitions.

# We expect that all license_kind rules used by an organization exist in a
# central place in their source repository.
#
# - This allows centralized audit and, with suport from the SCM, an assurance
#   that individual developers are not adding new license kinds to the code
#   base without authorization.
# - When third party packages are used, they might come with license rules
#   pointing to well known license_kinds from @rules_license/licenses.
#   At import time, users can mechanically transform those target paths from
#   @rules_license to their own license_kind repository.
# - The conditions for each license_kind may be customized for the organzation's
#   needs, and not match the conditions used by the canonical versions from
#   @rules_license.
# - In rare cases, a third_party project will define their own license_kinds.
#   There is no reasonable automatic handling of that. Organizations will have
#   to hand inspect the license text to see if it matches the conditions, and
#   then will have to hand import it to their private license_kind repository.

load("@rules_license//rules:license_kind.bzl", "license_kind")

package(default_visibility = ["//examples:__subpackages__"])

# license_kind rules generally appear in a central location per workspace. They
# are intermingled with normal target build rules
license_kind(
    name = "generic_notice",
    conditions = [
        "notice",
    ],
)

license_kind(
    name = "generic_restricted",
    conditions = [
        "restricted",
    ],
)

license_kind(
    name = "unencumbered",
    conditions = [],  # none
)

license_kind(
    name = "lgpl_like",
    conditions = [
        "restricted_if_statically_linked",
    ],
)

license_kind(
    name = "acme_corp_paid",
    conditions = [
        "whitelist:acme_corp_paid",
    ],
)
