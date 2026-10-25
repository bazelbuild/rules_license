"""Analysis tests for package_info."""

load("@rules_testing//lib:analysis_test.bzl", "analysis_test", "test_suite")
load("@rules_testing//lib:truth.bzl", "subjects")
load("//rules:package_info.bzl", "package_info")
load("//rules:providers.bzl", "ExperimentalMetadataInfo", "PackageInfo")

def _test_package_info_default_package_name(name):
    package_info(
        name = name + "_subject",
    )
    analysis_test(
        name = name,
        impl = _test_package_info_default_package_name_impl,
        target = name + "_subject",
        provider_subject_factories = [
            _package_info_subject_factory,
            _experimental_metadata_info_subject_factory,
        ],
    )

def _test_package_info_default_package_name_impl(env, target):
    env.expect.that_target(target).provider(PackageInfo).package_name().equals("tests/package_info")
    env.expect.that_target(target).provider(ExperimentalMetadataInfo).data().get(
        "package_name",
        factory = subjects.str,
    ).equals("tests/package_info")

_package_info_subject_factory = struct(
    type = PackageInfo,
    name = "PackageInfo",
    factory = lambda actual, *, meta: subjects.struct(
        actual,
        meta = meta,
        attrs = {
            "package_name": subjects.str,
        },
    ),
)

_experimental_metadata_info_subject_factory = struct(
    type = ExperimentalMetadataInfo,
    name = "ExperimentalMetadataInfo",
    factory = lambda actual, *, meta: subjects.struct(
        actual,
        meta = meta,
        attrs = {
            "data": subjects.dict,
        },
    ),
)

def starlark_tests(name):
    test_suite(
        name = name,
        tests = [
            _test_package_info_default_package_name,
        ],
    )
