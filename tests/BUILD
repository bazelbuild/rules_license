"""Test cases for license rules."""

load("@rules_license//rules:compliance.bzl", "check_license")
load("@rules_license//rules:license.bzl", "license")
load("@rules_license//rules:license_kind.bzl", "license_kind")
load("@rules_license//tools:test_helpers.bzl", "golden_test")

package(default_applicable_licenses = [":license"])

# license_kind rules generally appear in a central location per workspace. They
# are intermingled with normal target build rules
license_kind(
    name = "generic_notice_license",
    conditions = [
        "notice",
    ],
)

license_kind(
    name = "generic_restricted_license",
    conditions = [
        "restricted",
    ],
)

# The default license for an entire package is typically named "license".
license(
    name = "license",
    package_name = "A test case package",
    # Note the UTF-8 encoded copyright symbol.
    copyright_notice = "Copyright © 2019 Uncle Toasty",
    license_kinds = [":generic_notice_license"],
    # Note. This need not be precise. If a downloader creates the license
    # clause for you, then it should use the absolute download URL.
    package_url = "http://github.com/bazelbuild/rules_license",
    package_version = "0.0.4",
)

license(
    name = "license_for_extra_feature",
    package_name = "A test case package",
    license = "LICENSE.extra",
    license_kinds = [":generic_restricted_license"],
)

cc_binary(
    name = "hello",
    srcs = ["hello.cc"],
    deps = [
        ":c_bar",
    ],
)

cc_library(
    name = "c_bar",
    srcs = ["bar.cc"],
)

java_binary(
    name = "hello_java",
    srcs = ["Hello.java"],
    # Add an addition license to this target, beyond what my deps have.
    applicable_licenses = [
        ":license_for_extra_feature",
    ],
    main_class = "Hello",
    deps = [
        ":j_bar",
    ],
)

java_library(
    name = "j_bar",
    srcs = ["Bar.java"],
)

check_license(
    name = "check_cc_app",
    check_conditions = False,
    copyright_notices = "hello_cc_copyrights.txt",
    license_texts = "hello_cc_licenses.txt",
    report = "hello_cc_report",
    deps = [
        ":hello",
    ],
)

check_license(
    name = "check_java_app",
    check_conditions = False,
    copyright_notices = "hello_java_copyrights.txt",
    license_texts = "hello_java_licenses.txt",
    report = "hello_java_report",
    deps = [
        ":hello_java",
    ],
)

golden_test(
    name = "verify_cc_app_test",
    golden = "hello_cc_copyrights.golden",
    subject = ":hello_cc_copyrights.txt",
)

golden_test(
    name = "verify_java_app_test",
    golden = "hello_java_copyrights.golden",
    subject = ":hello_java_copyrights.txt",
)
