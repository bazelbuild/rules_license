load("@rules_java//java:defs.bzl", "java_binary", "java_library")
load("@rules_license//rules:license.bzl", "license")
load("@rules_license//rules:compliance.bzl", "licenses_used")
load("@rules_license//rules:license_policy_check.bzl", "license_policy_check")

package(	
    default_visibility = ["//visibility:public"],
    default_applicable_licenses = [":license"],
)

license(
    name = "license",
    package_name = "Compare Numbers",
    license_kinds = [
        "//examples/using_rules_jvm_external/compliance/licenses:MIT",
    ],
    license_text = "LICENSE",
)

java_binary(
    name = "compare_nums",
    main_class = "CompareNums",
    runtime_deps = [":compare_nums_lib"],
)

java_library(
    name = "compare_nums_lib",
    srcs = ["CompareNums.java"],
    deps = [
        "@maven//:com_google_guava_guava",
    ],
)

licenses_used(
    name = "compare_nums_licenses",
    deps = [":compare_nums_lib"],
)

license_policy_check(
    name = "check_compare_nums",
    policy = "@rules_license//examples/using_rules_jvm_external/compliance/policies:production_service",
    # This target attribute expects 1 file, so it cannot run
    # a check agains a java_binary target, which produces 2 files
    target = ":compare_nums_lib",
)
