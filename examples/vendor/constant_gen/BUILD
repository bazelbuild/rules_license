# An example of a code generator with a distinct license for the generated code.

load(":defs.bzl", "constant_gen")
load("@rules_license//rules:compliance.bzl", "licenses_used")
load("@rules_license//rules:license.bzl", "license")
load("@rules_license//tools:test_helpers.bzl", "golden_test")

package(
    default_applicable_licenses = [":license"],
    default_visibility = ["//visibility:public"],
)

# The default license for an entire package is typically named "license".
license(
    name = "license",
    package_name = "Trivial Code Generator",
    license_kinds = [
        "@rules_license//examples/my_org/licenses:generic_restricted",
    ],
    license_text = "LICENSE",
)

license(
    name = "license_for_emitted_code",
    package_name = "Trivial Code Generator Output",
    license = "LICENSE.on_output",
    license_kinds = [
        "@rules_license//examples/my_org/licenses:unencumbered",
    ],
)

# The generator itself will be licensed under :license
py_binary(
    name = "constant_generator",
    srcs = ["constant_generator.py"],
    python_version = "PY3",
)

# Sample: This target will be licensed under :license_for_emitted_code
constant_gen(
    name = "libhello",
    text = "Hello, world.",
    var = "hello_world",
)

# Verify the licenses are what we expect
licenses_used(
    name = "generator_licenses",
    out = "generator_licenses.json",
    deps = [":constant_generator"],
)

golden_test(
    name = "verify_generator_licenses",
    golden = "generator_licenses.golden",
    subject = ":generator_licenses.json",
)

licenses_used(
    name = "generated_code_licenses",
    # Note: using default output file name
    deps = [":libhello"],
)

golden_test(
    name = "verify_generated_code_licenses",
    golden = "generated_code_licenses.golden",
    subject = ":generated_code_licenses.json",
)
