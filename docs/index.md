# bazelbuild/rules_license

Bazel rules for defining and using package licensing and other metadata. Use bazel-ssc@bazel.build for discussion.

## Library Authors

If you are writing a library, you should declare the licenses that apply to your library using the
`license` rule. This will allow users of your library to easily determine the licenses that apply to
your library.

In your root `BUILD.bazel` file:

```python
load("@rules_license//rules:license.bzl", "license")

license(
    name = "license",
    license_text = "LICENSE.txt", # This is the license file that you keep at the root of your repository
    license_kind = "@rules_license//licenses/spdx:YOUR_SPDX_LICENSE_KIND",
)
```

To see all of the supported spdx license kinds that `rules_license` supports, go [here](license_kinds.md).

In a root-level `REPO.bazel` file:

```python
repo(
    default_package_metadata = ["//:license"],
)
```

This will mark all targets in your repo as using the license that your configured in your root BUILD
file.

## Generating reports / SBOMs

Tooling for license reporting is under active development. See the 'examples' directory in the
rules_license repo for examples of how to generate reports.

## Reference

* [Rules and provider reference](latest.md)
* [SPDX license kinds](license_kinds.md)
