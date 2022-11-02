"""Tests for google3.tools.build_defs.license.tests.hello_licenses."""

import os

import unittest
from tests import license_test_utils


class HelloLicensesTest(unittest.TestCase):

  def test_has_expected_licenses(self):
    package_base = license_test_utils.LICENSE_PACKAGE_BASE
    licenses_info = license_test_utils.load_licenses_info(
        os.path.join(os.path.dirname(__file__), "hello_licenses.json"))
    licenses_info = license_test_utils.filter_dependencies(
        licenses_info,
        target_filter=lambda targ: targ.startswith(package_base),
        licenses_filter=lambda lic: lic.startswith(package_base))

    expected = {
        "/tests:hello": [
            "/tests:license",
        ],
        "/tests:c_bar": [
            "/tests:license",
            "/tests:license_for_extra_feature",
        ],
    }
    license_test_utils.check_licenses_of_dependencies(
        self, licenses_info, expected)


if __name__ == "__main__":
  unittest.main()
