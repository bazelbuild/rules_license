"""Tests for google3.tools.build_defs.license.tests.apps.an_app_licenses."""

import os

import unittest
from tests import license_test_utils


class AnAppLicensesTest(unittest.TestCase):

  def test_has_expected_licenses(self):
    package_base = license_test_utils.LICENSE_PACKAGE_BASE
    licenses_info = license_test_utils.load_licenses_info(
        os.path.join(os.path.dirname(__file__), "an_app_licenses.json"))
    licenses_info = license_test_utils.filter_dependencies(
        licenses_info,
        target_filter=lambda targ: targ.startswith(package_base),
        licenses_filter=lambda lic: lic.startswith(package_base))

    expected = {
        "/tests/thrdparty:new_style_lib": [
            "/tests/thrdparty:license",
        ],
    }
    license_test_utils.check_licenses_of_dependencies(
        self, licenses_info, expected)


if __name__ == "__main__":
  unittest.main()
