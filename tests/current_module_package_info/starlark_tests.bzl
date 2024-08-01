load("//rules:current_module_package_info.bzl", "current_module_package_info")
load("//rules:providers.bzl", "PackageInfo")
load("//:version.bzl", "version")
load("@rules_testing//lib:analysis_test.bzl", "analysis_test", "test_suite")
load("@rules_testing//lib:truth.bzl", "subjects")

def _test_current_module_package_info(name):
    current_module_package_info(
        name = name + "_subject",
    )
    analysis_test(
        name = name,
        impl = _test_current_module_package_info_impl,
        target = name + "_subject",
        provider_subject_factories = [_package_info_subject_factory],
    )

def _test_current_module_package_info_impl(env, target):
    env.expect.that_target(target).has_provider(PackageInfo)
    subject = env.expect.that_target(target).provider(PackageInfo)
    subject.package_name().equals("rules_license")
    subject.package_url().equals("https://bcr.bazel.build/modules/rules_license/{}/source.json".format(version))
    subject.package_version().equals(version)
    subject.purl().equals("pkg:bazel/rules_license@{}".format(version))

def _test_current_module_package_info_custom_registry(name):
    current_module_package_info(
        name = name + "_subject",
        registry = "https://example.com/registry/",
    )
    analysis_test(
        name = name,
        impl = _test_current_module_package_info_custom_registry_impl,
        target = name + "_subject",
        provider_subject_factories = [_package_info_subject_factory],
    )

def _test_current_module_package_info_custom_registry_impl(env, target):
    env.expect.that_target(target).has_provider(PackageInfo)
    subject = env.expect.that_target(target).provider(PackageInfo)
    subject.package_name().equals("rules_license")
    subject.package_url().equals("https://example.com/registry/modules/rules_license/{}/source.json".format(version))
    subject.package_version().equals(version)
    subject.purl().equals("pkg:bazel/rules_license@{}?repository_url=https://example.com/registry".format(version))

_package_info_subject_factory = struct(
    type = PackageInfo,
    name = "PackageInfo",
    factory = lambda actual, *, meta: subjects.struct(
        actual,
        meta = meta,
        attrs = {
            "package_name": subjects.str,
            "package_url": subjects.str,
            "package_version": subjects.str,
            "purl": subjects.str,
        },
    ),
)

def starlark_tests(name):
    test_suite(
        name = name,
        tests = [
            _test_current_module_package_info,
            _test_current_module_package_info_custom_registry,
        ],
    )