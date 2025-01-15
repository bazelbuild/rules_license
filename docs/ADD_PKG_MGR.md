# Adding support for a new package manager

Bazel largely relies on existing package managers for each language ecosystem to fetch dependencies.
Thus the knowledge of provenance and package metadata needs to be plumbed through these tools.

## 

In BUILD targets generated for third-party packages, implementations must create one of the following:

```starlark
load("@rules_license//rules:license.bzl", "license")

package(
   default_package_metadata = [":license"],
)

license(
  name = "license",
  src = ":LICENSE.txt",
  license_kind = ["@rules_license//licenses/spdx:Apache-2.0"],
)
```
