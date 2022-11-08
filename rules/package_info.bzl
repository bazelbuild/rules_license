# Copyright 2022 Google LLC
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
    "@rules_license//rules:providers.bzl",
    "MetadataInfo",
    "PackageInfo",
)

# Debugging verbosity
_VERBOSITY = 0

def _debug(loglevel, msg):
    if _VERBOSITY > loglevel:
        print(msg)  # buildifier: disable=print

#
# package_info()
#

def _package_info_impl(ctx):
    provider = PackageInfo(
        type = "package_info",
        label = ctx.label,
        copyright_notice = ctx.attr.copyright_notice,
        package_name = ctx.attr.package_name or ctx.build_file_path.rstrip("/BUILD"),
        package_url = ctx.attr.package_url,
        package_version = ctx.attr.package_version,
    )
    generic_provider = MetadataInfo(
        type = "package_info2",
        label = ctx.label,
        # Alternate design.  data should be a package_info. That may be easier
        # to work with. It probably uses more memory though. While we have a
        # map here instead of an object pointer, the provider is basically
        # a name/value map anyway, so there is no space savings.
        data = {
            # DNS: Remove Ahoy:
            "copyright_notice": "Ahoy: " + ctx.attr.copyright_notice,
            "package_name": ctx.attr.package_name or ctx.build_file_path.rstrip("/BUILD"),
            "package_url": ctx.attr.package_url,
            # DNS: remove ++
            "package_version": ctx.attr.package_version + "++"
        }
    )
    _debug(0, provider)
    return [provider, generic_provider]

_package_info = rule(
    implementation = _package_info_impl,
    attrs = {
        "copyright_notice": attr.string(
            doc = "Copyright notice.",
        ),
        "package_name": attr.string(
            doc = "A human readable name identifying this package." +
                  " This may be used to produce an index of OSS packages used by" +
                  " an applicatation.",
        ),
        "package_url": attr.string(
            doc = "The URL this instance of the package was download from." +
                  " This may be used to produce an index of OSS packages used by" +
                  " an applicatation.",
        ),
        "package_version": attr.string(
            doc = "A human readable version string identifying this package." +
                  " This may be used to produce an index of OSS packages used" +
                  " by an applicatation.  It should be a value that" +
                  " increases over time, rather than a commit hash."
        ),
    },
)

# buildifier: disable=function-docstring-args
def package_info(
        name,
        copyright_notice = None,
        package_name = None,
        package_url = None,
        package_version = None,
        visibility = ["//visibility:public"]):
    """Wrapper for package_info rule.

    Args:
      name: str target name.
      license_kind: label a single license_kind. Only one of license_kind or license_kinds may
                    be specified
      license_kinds: list(label) list of license_kind targets.
      copyright_notice: str Copyright notice associated with this package.
      package_name : str A human readable name identifying this package. This
                     may be used to produce an index of OSS packages used by
                     an application.
      tags: list(str) tags applied to the rule
    """
    _package_info(
        name = name,
        copyright_notice = copyright_notice,
        package_name = package_name,
        package_url = package_url,
        package_version = package_version,
        applicable_licenses = [],
        visibility = visibility,
        tags = [],
        testonly = 0,
    )
