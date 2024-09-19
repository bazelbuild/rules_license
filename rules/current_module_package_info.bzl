# Copyright 2024 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
"""Rules for declaring metadata about a package."""

load(
    "@rules_license//rules:package_info.bzl",
    "package_info",
)

#
# current_module_package_info()
#

_DEFAULT_REGISTRY = "https://bcr.bazel.build"

# buildifier: disable=function-docstring-args
def current_module_package_info(
        name,
        registry = _DEFAULT_REGISTRY,
        visibility = ["//:__subpackages__"],
        **kwargs):
    """A wrapper around package_info with info for the current Bazel module.

    If `//:package_info` is a target of this macro, it can be registered for the
    entire module by adding a `REPO.bazel` file with the following content to
    the root of the module:

    ```
    repo(default_package_metadata = ["//:package_info"])
    ```

    @wraps(package_info)

    Args:
      name: str target name.
      registry: str the URL of the registry hosting the module.
      visibility: list[str] visibility of the target.
      kwargs: other args. Most are ignored.
    """

    package_name = native.module_name()
    package_version = native.module_version()

    normalized_registry = registry.rstrip("/")
    package_url = "{registry}/modules/{name}/{version}/source.json".format(
        registry = normalized_registry,
        name = package_name,
        version = package_version,
    )
    purl = "pkg:bazel/{name}@{version}{registry_qualifier}".format(
        name = package_name,
        version = package_version,
        registry_qualifier = "" if normalized_registry == _DEFAULT_REGISTRY else "?repository_url=" + normalized_registry,
    )

    package_info(
        name = name,
        package_name = package_name,
        package_url = package_url,
        package_version = package_version,
        purl = purl,
        visibility = visibility,
        **kwargs
    )
