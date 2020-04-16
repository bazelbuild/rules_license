# Examples of applications and interactions with licenses

load("@rules_license//examples/vendor/constant_gen:defs.bzl", "constant_gen")
load("@rules_license//rules:compliance.bzl", "check_license", "licenses_used")
load("@rules_license//rules:license_policy_check.bzl", "license_policy_check")
load("@rules_license//tools:test_helpers.bzl", "golden_test")

cc_binary(
    name = "my_server",
    srcs = ["server.cc"],
    deps = [
        ":message",
        "@rules_license//examples/vendor/libhhgttg",
    ],
)

# Sample
constant_gen(
    name = "message",
    text = "Hello, world.",
    var = "server_message",
)

license_policy_check(
    name = "check_server",
    policy = "@rules_license//examples/my_org/compliance:production_service",
    target = ":my_server",
)

cc_binary(
    name = "my_violating_server",
    srcs = ["server.cc"],
    deps = [
        ":message",
        "@rules_license//examples/vendor/acme",
        "@rules_license//examples/vendor/libhhgttg",
    ],
)

license_policy_check(
    name = "check_violating_server",
    policy = "@rules_license//examples/my_org/compliance:production_service",
    tags = [
        "manual",
        "notap",
    ],
    target = ":my_violating_server",
)

#
# Verify the licenses are what we expect. The golden output shows that
# :my_server only uses the unencumbered license type.

licenses_used(
    name = "server_licenses",
    out = "server_licenses.json",
    deps = [":my_server"],
)

golden_test(
    name = "verify_server_licenses_test",
    golden = "server_licenses.golden",
    subject = ":server_licenses.json",
)
