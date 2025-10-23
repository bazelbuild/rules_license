# Example of an unmigrated package.

load("@rules_cc//cc:cc_library.bzl", "cc_library")

package(default_visibility = [
    "//tests:__subpackages__",
])

licenses(["unencumbered"])

cc_library(
    name = "library_with_legacy_license_clause",
    srcs = ["file_under_notice.cc"],
)

cc_library(
    name = "another_library_with_legacy_license_clause",
    srcs = ["file_under_notice.cc"],
)
