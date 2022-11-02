load(":android_mock.bzl", "android_binary", "android_library")
load("@rules_license//tools:test_helpers.bzl", "golden_cmd_test")


# These two rules today capture what an android_binary would look like.
# This rule represents the Android specific code that displays licenses
# on the display. Note that it does not depend on anything to get the
# license contents; the implementation of these rules macros handle that
# detail.
android_library(
    name = "licenses",
    srcs = [
        "license_display.sh",
    ],
    data = [
      "@rules_license//distro:distro",
    ],
)

# This captures how the application would be built. The dependencies of this
# rule are crawled to identify third-party licenses in use. The macro definition
# of this rule creates a graph to capture that process of identifying licenses,
# building the licenses target, and finally invoking the "real" android_binary
# rule to build the final output with the injected license content.
android_binary(
    name = "main",
    srcs = ["main.sh"],
    deps = [
    ],
    data = [
        ":licenses",
    ],
)

golden_cmd_test(
    name = "main_test",
    srcs = [],
    cmd = "$(location :main)",
    tools = [":main"],
    golden = "main_golden.txt",
)
