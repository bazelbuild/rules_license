# Test cases for license rules.

load("@rules_license//rules:compliance.bzl", "check_license", "licenses_used")
load("@rules_license//rules:license.bzl", "license")
load("@rules_license//rules:license_kind.bzl", "license_kind")

package(
    default_applicable_licenses = [":license"],
    default_visibility = [
        "//examples:__subpackages__",
        "//tests:__subpackages__",
    ],
)

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
    license_kinds = [":generic_restricted_license"],
    license_text = "LICENSE.extra",
)

# This license is not in the "compliance" namespace and
# therefore should not show up in the report verified by
# :verify_cc_app_test
license(
    name = "internal_non_compliance_license",
    namespace = "test_namespace",
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
    srcs = [
        "bar.cc",
    ],
    applicable_licenses = [
        ":license",
        ":license_for_extra_feature",
        ":internal_non_compliance_license",
    ],
    deps = [
        "@rules_license//tests/legacy:another_library_with_legacy_license_clause",
        "@rules_license//tests/legacy:library_with_legacy_license_clause",
    ],
)

java_binary(
    name = "hello_java",
    srcs = ["Hello.java"],
    # Add an addition license to this target, beyond what my deps have.
    applicable_licenses = [
        ":license_for_extra_feature",
    ],
    javacopts = ["-Xep:DefaultPackage:OFF"],
    main_class = "Hello",
    deps = [
        ":j_bar",
    ],
)

java_library(
    name = "j_bar",
    srcs = ["Bar.java"],
    javacopts = ["-Xep:DefaultPackage:OFF"],
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

licenses_used(
    name = "hello_licenses",
    out = "hello_licenses.json",
    deps = [":hello"],
)

py_test(
    name = "hello_licenses_test",
    srcs = ["hello_licenses_test.py"],
    data = [
        ":hello_licenses.json",
        ":hello_cc_copyrights.txt",
    ],
    python_version = "PY3",
    deps = [
        ":license_test_utils",
    ],
)

py_library(
    name = "license_test_utils",
    srcs = ["license_test_utils.py"],
    srcs_version = "PY3",
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


license(
    name = "license_with_generated_text",
    license_text = ":created_license",
    license_kinds = [":generic_notice_license"],
)

genrule(
    name = "created_license",
    outs = ["something.text"],
    cmd = "echo hello >$@",
)

