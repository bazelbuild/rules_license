<!-- Generated with Stardoc: http://skydoc.bazel.build -->

Rules for declaring the compliance licenses used by a package.



<a id="license"></a>

## license

<pre>
license(<a href="#license-name">name</a>, <a href="#license-copyright_notice">copyright_notice</a>, <a href="#license-license_kinds">license_kinds</a>, <a href="#license-license_text">license_text</a>, <a href="#license-namespace">namespace</a>, <a href="#license-package_name">package_name</a>, <a href="#license-package_url">package_url</a>,
         <a href="#license-package_version">package_version</a>)
</pre>



**ATTRIBUTES**


| Name  | Description | Type | Mandatory | Default |
| :------------- | :------------- | :------------- | :------------- | :------------- |
| <a id="license-name"></a>name |  A unique name for this target.   | <a href="https://bazel.build/concepts/labels#target-names">Name</a> | required |  |
| <a id="license-copyright_notice"></a>copyright_notice |  Copyright notice.   | String | optional | <code>""</code> |
| <a id="license-license_kinds"></a>license_kinds |  License kind(s) of this license. If multiple license kinds are listed in the LICENSE file, and they all apply, then all should be listed here. If the user can choose a single one of many, then only list one here.   | <a href="https://bazel.build/concepts/labels">List of labels</a> | optional | <code>[]</code> |
| <a id="license-license_text"></a>license_text |  The license file.   | <a href="https://bazel.build/concepts/labels">Label</a> | optional | <code>LICENSE</code> |
| <a id="license-namespace"></a>namespace |  A human readable name used to organize licenses into categories. This is used in google3 to differentiate third party licenses used for compliance versus internal licenses used by SLAsan for internal teams' SLAs.   | String | optional | <code>""</code> |
| <a id="license-package_name"></a>package_name |  A human readable name identifying this package. This may be used to produce an index of OSS packages used by an applicatation.   | String | optional | <code>""</code> |
| <a id="license-package_url"></a>package_url |  The URL this instance of the package was download from. This may be used to produce an index of OSS packages used by an applicatation.   | String | optional | <code>""</code> |
| <a id="license-package_version"></a>package_version |  A human readable version string identifying this package. This may be used to produce an index of OSS packages used by an applicatation.  It should be a value that increases over time, rather than a commit hash.   | String | optional | <code>""</code> |



<!-- Generated with Stardoc: http://skydoc.bazel.build -->

Proof of concept. License restriction.

<a id="license_kind"></a>

## license_kind

<pre>
license_kind(<a href="#license_kind-name">name</a>, <a href="#license_kind-canonical_text">canonical_text</a>, <a href="#license_kind-conditions">conditions</a>, <a href="#license_kind-long_name">long_name</a>, <a href="#license_kind-url">url</a>)
</pre>



**ATTRIBUTES**


| Name  | Description | Type | Mandatory | Default |
| :------------- | :------------- | :------------- | :------------- | :------------- |
| <a id="license_kind-name"></a>name |  A unique name for this target.   | <a href="https://bazel.build/concepts/labels#target-names">Name</a> | required |  |
| <a id="license_kind-canonical_text"></a>canonical_text |  File containing the canonical text for this license. Must be UTF-8 encoded.   | <a href="https://bazel.build/concepts/labels">Label</a> | optional | <code>None</code> |
| <a id="license_kind-conditions"></a>conditions |  Conditions to be met when using software under this license.  Conditions are defined by the organization using this license.   | List of strings | required |  |
| <a id="license_kind-long_name"></a>long_name |  Human readable long name of license.   | String | optional | <code>""</code> |
| <a id="license_kind-url"></a>url |  URL pointing to canonical license definition   | String | optional | <code>""</code> |



<!-- Generated with Stardoc: http://skydoc.bazel.build -->

Rules for declaring metadata about a package.

<a id="package_info"></a>

## package_info

<pre>
package_info(<a href="#package_info-name">name</a>, <a href="#package_info-package_name">package_name</a>, <a href="#package_info-package_url">package_url</a>, <a href="#package_info-package_version">package_version</a>)
</pre>



**ATTRIBUTES**


| Name  | Description | Type | Mandatory | Default |
| :------------- | :------------- | :------------- | :------------- | :------------- |
| <a id="package_info-name"></a>name |  A unique name for this target.   | <a href="https://bazel.build/concepts/labels#target-names">Name</a> | required |  |
| <a id="package_info-package_name"></a>package_name |  A human readable name identifying this package. This may be used to produce an index of OSS packages used by an applicatation.   | String | optional | <code>""</code> |
| <a id="package_info-package_url"></a>package_url |  The URL this instance of the package was download from. This may be used to produce an index of OSS packages used by an applicatation.   | String | optional | <code>""</code> |
| <a id="package_info-package_version"></a>package_version |  A human readable version string identifying this package. This may be used to produce an index of OSS packages used by an applicatation.  It should be a value that increases over time, rather than a commit hash.   | String | optional | <code>""</code> |



<!-- Generated with Stardoc: http://skydoc.bazel.build -->

Providers for license rules.

<a id="LicenseInfo"></a>

## LicenseInfo

<pre>
LicenseInfo(<a href="#LicenseInfo-copyright_notice">copyright_notice</a>, <a href="#LicenseInfo-label">label</a>, <a href="#LicenseInfo-license_kinds">license_kinds</a>, <a href="#LicenseInfo-license_text">license_text</a>, <a href="#LicenseInfo-namespace">namespace</a>, <a href="#LicenseInfo-package_name">package_name</a>,
            <a href="#LicenseInfo-package_url">package_url</a>, <a href="#LicenseInfo-package_version">package_version</a>)
</pre>

Provides information about a license instance.

**FIELDS**


| Name  | Description |
| :------------- | :------------- |
| <a id="LicenseInfo-copyright_notice"></a>copyright_notice |  string: Human readable short copyright notice    |
| <a id="LicenseInfo-label"></a>label |  Label: label of the license rule    |
| <a id="LicenseInfo-license_kinds"></a>license_kinds |  list(LicenseKindInfo): License kinds    |
| <a id="LicenseInfo-license_text"></a>license_text |  string: The license file path    |
| <a id="LicenseInfo-namespace"></a>namespace |  string: namespace of the license rule    |
| <a id="LicenseInfo-package_name"></a>package_name |  string: Human readable package name    |
| <a id="LicenseInfo-package_url"></a>package_url |  URL from which this package was downloaded.    |
| <a id="LicenseInfo-package_version"></a>package_version |  Human readable version string    |



<!-- Generated with Stardoc: http://skydoc.bazel.build -->

Providers for license rules.

<a id="LicenseKindInfo"></a>

## LicenseKindInfo

<pre>
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

Providers for license rules.

<a id="PackageInfo"></a>

## PackageInfo

<pre>
PackageInfo(<a href="#PackageInfo-type">type</a>, <a href="#PackageInfo-label">label</a>, <a href="#PackageInfo-package_name">package_name</a>, <a href="#PackageInfo-package_url">package_url</a>, <a href="#PackageInfo-package_version">package_version</a>)
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



