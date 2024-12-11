<!-- Generated with Stardoc: http://skydoc.bazel.build -->

Rules for declaring the compliance licenses used by a package.


<!-- Generated with Stardoc: http://skydoc.bazel.build -->

Proof of concept. License restriction.


<!-- Generated with Stardoc: http://skydoc.bazel.build -->

Rules for declaring metadata about a package.


<!-- Generated with Stardoc: http://skydoc.bazel.build -->

Basic providers for license rules.

This file should only contain the basic providers needed to create
license and package_info declarations. Providers needed to gather
them are declared in other places.

<a id="LicenseInfo"></a>

## LicenseInfo

<pre>
load("@rules_license//rules:providers.bzl", "LicenseInfo")

LicenseInfo(<a href="#LicenseInfo-copyright_notice">copyright_notice</a>, <a href="#LicenseInfo-label">label</a>, <a href="#LicenseInfo-license_kinds">license_kinds</a>, <a href="#LicenseInfo-license_text">license_text</a>, <a href="#LicenseInfo-package_name">package_name</a>, <a href="#LicenseInfo-package_url">package_url</a>,
            <a href="#LicenseInfo-package_version">package_version</a>)
</pre>

Provides information about a license instance.

**FIELDS**

| Name  | Description |
| :------------- | :------------- |
| <a id="LicenseInfo-copyright_notice"></a>copyright_notice |  string: Human readable short copyright notice    |
| <a id="LicenseInfo-label"></a>label |  Label: label of the license rule    |
| <a id="LicenseInfo-license_kinds"></a>license_kinds |  list(LicenseKindInfo): License kinds    |
| <a id="LicenseInfo-license_text"></a>license_text |  string: The license file path    |
| <a id="LicenseInfo-package_name"></a>package_name |  string: Human readable package name    |
| <a id="LicenseInfo-package_url"></a>package_url |  URL from which this package was downloaded.    |
| <a id="LicenseInfo-package_version"></a>package_version |  Human readable version string    |



<!-- Generated with Stardoc: http://skydoc.bazel.build -->

Basic providers for license rules.

This file should only contain the basic providers needed to create
license and package_info declarations. Providers needed to gather
them are declared in other places.

<a id="LicenseKindInfo"></a>

## LicenseKindInfo

<pre>
load("@rules_license//rules:providers.bzl", "LicenseKindInfo")

LicenseKindInfo(<a href="#LicenseKindInfo-conditions">conditions</a>, <a href="#LicenseKindInfo-label">label</a>, <a href="#LicenseKindInfo-long_name">long_name</a>, <a href="#LicenseKindInfo-name">name</a>)
</pre>

Provides information about a license_kind instance.

**FIELDS**

| Name  | Description |
| :------------- | :------------- |
| <a id="LicenseKindInfo-conditions"></a>conditions |  list(string): List of conditions to be met when using this packages under this license.    |
| <a id="LicenseKindInfo-label"></a>label |  Label: The full path to the license kind definition.    |
| <a id="LicenseKindInfo-long_name"></a>long_name |  string: Human readable license name    |
| <a id="LicenseKindInfo-name"></a>name |  string: Canonical license name    |



<!-- Generated with Stardoc: http://skydoc.bazel.build -->

Basic providers for license rules.

This file should only contain the basic providers needed to create
license and package_info declarations. Providers needed to gather
them are declared in other places.

<a id="PackageInfo"></a>

## PackageInfo

<pre>
load("@rules_license//rules:providers.bzl", "PackageInfo")

PackageInfo(<a href="#PackageInfo-type">type</a>, <a href="#PackageInfo-label">label</a>, <a href="#PackageInfo-package_name">package_name</a>, <a href="#PackageInfo-package_url">package_url</a>, <a href="#PackageInfo-package_version">package_version</a>, <a href="#PackageInfo-purl">purl</a>)
</pre>

Provides information about a package.

**FIELDS**

| Name  | Description |
| :------------- | :------------- |
| <a id="PackageInfo-type"></a>type |  string: How to interpret data    |
| <a id="PackageInfo-label"></a>label |  Label: label of the package_info rule    |
| <a id="PackageInfo-package_name"></a>package_name |  string: Human readable package name    |
| <a id="PackageInfo-package_url"></a>package_url |  string: URL from which this package was downloaded.    |
| <a id="PackageInfo-package_version"></a>package_version |  string: Human readable version string    |
| <a id="PackageInfo-purl"></a>purl |  string: package url matching the purl spec (https://github.com/package-url/purl-spec)    |



<!-- Generated with Stardoc: http://skydoc.bazel.build -->

Rules and macros for collecting LicenseInfo providers.

<a id="gather_metadata_info"></a>

## gather_metadata_info

<pre>
load("@rules_license//rules_gathering:gather_metadata.bzl", "gather_metadata_info")

gather_metadata_info(<a href="#gather_metadata_info-name">name</a>)
</pre>

Collects LicenseInfo providers into a single TransitiveMetadataInfo provider.

**ASPECT ATTRIBUTES**



**ATTRIBUTES**


| Name  | Description | Type | Mandatory | Default |
| :------------- | :------------- | :------------- | :------------- | :------------- |
| <a id="gather_metadata_info-name"></a>name |  A unique name for this target.   | <a href="https://bazel.build/concepts/labels#target-names">Name</a> | required |  |



<!-- Generated with Stardoc: http://skydoc.bazel.build -->

Rules and macros for collecting LicenseInfo providers.

<a id="gather_metadata_info_and_write"></a>

## gather_metadata_info_and_write

<pre>
load("@rules_license//rules_gathering:gather_metadata.bzl", "gather_metadata_info_and_write")

gather_metadata_info_and_write(<a href="#gather_metadata_info_and_write-name">name</a>)
</pre>

Collects TransitiveMetadataInfo providers and writes JSON representation to a file.

Usage:
  bazel build //some:target           --aspects=@rules_license//rules_gathering:gather_metadata.bzl%gather_metadata_info_and_write
      --output_groups=licenses

**ASPECT ATTRIBUTES**



**ATTRIBUTES**


| Name  | Description | Type | Mandatory | Default |
| :------------- | :------------- | :------------- | :------------- | :------------- |
| <a id="gather_metadata_info_and_write-name"></a>name |  A unique name for this target.   | <a href="https://bazel.build/concepts/labels#target-names">Name</a> | required |  |



<!-- Generated with Stardoc: http://skydoc.bazel.build -->

Rules and macros for collecting package metdata providers.

<a id="trace"></a>

## trace

<pre>
load("@rules_license//rules_gathering:trace.bzl", "trace")

trace(<a href="#trace-name">name</a>)
</pre>

Used to allow the specification of a target to trace while collecting license dependencies.

**ATTRIBUTES**


| Name  | Description | Type | Mandatory | Default |
| :------------- | :------------- | :------------- | :------------- | :------------- |
| <a id="trace-name"></a>name |  A unique name for this target.   | <a href="https://bazel.build/concepts/labels#target-names">Name</a> | required |  |



