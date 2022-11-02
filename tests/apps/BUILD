# Test cases for license rules: Sample app

load("@rules_license//rules:compliance.bzl", "licenses_used")

package(default_visibility = ["//examples:__subpackages__"])

# Note that the app explicitly depends only on a library and some legacy
# style licensed code.
cc_binary(
    name = "an_app",
    srcs = ["an_app.cc"],
    deps = [
        ":level4",
        # "@rules_license//rules/tests/legacy:another_library_with_legacy_license_clause",
        # "@rules_license//rules/tests/legacy:library_with_legacy_license_clause",
    ],
)

# pointless chain of libraries to show transitive rule gathering, culminating
# in a diamond dependency on a library under license.
# Note that the lowest level depends on some third party code
[
    genrule(
        name = "level_%d_src" % level,
        outs = ["level_%d.cc" % level],
        # Note to reviewers: This should use string format, but format
        # is broken when
        cmd = """cat >$@ <<END
            #include <iostream>
            extern void {lower}();
            void lib_level_{level}() {{
                std::cout << "This is level {level}" << std::endl;
                {lower}();
                }}
END
            """.format(
            level = level,
            lower = "lib_level_%d" % (level - 1) if level > 0 else "new_lib_func",
        ),
    )
    for level in range(5)
]

[
    cc_library(
        name = "level%d" % level,
        srcs = [":level_%d.cc" % level],
        deps = [
            (":level%d" % (level - 1) if level > 0 else "@rules_license//tests/thrdparty:new_style_lib"),
        ],
    )
    for level in range(5)
]

licenses_used(
    name = "an_app_licenses",
    out = "an_app_licenses.json",
    deps = [":an_app"],
)

# Examining the golden file shows that we depend on both kinds of license.
py_test(
    name = "an_app_licenses_test",
    srcs = ["an_app_licenses_test.py"],
    data = [":an_app_licenses.json"],
    python_version = "PY3",
    deps = [
        "@rules_license//tests:license_test_utils",
    ],
)
