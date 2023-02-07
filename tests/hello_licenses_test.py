"""Tests for google3.tools.build_defs.license.tests.hello_licenses."""

import codecs
import os

import unittest
from tests import license_test_utils


class HelloLicensesTest(unittest.TestCase):

  def test_has_expected_licenses(self):
    licenses_info = license_test_utils.load_licenses_info(
        os.path.join(os.path.dirname(__file__), "hello_licenses.json"))

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

  def test_has_expected_copyrights(self):
    copyrights_file = os.path.join(os.path.dirname(__file__),
                                   "hello_cc_copyrights.txt")
    with codecs.open(copyrights_file, encoding="utf-8") as inp:
      copyrights = inp.read().split('\n')
      self.assertIn(
          "package(A test case package/0.0.4), copyright(Copyright © 2019 Uncle Toasty)",
          copyrights)
      self.assertIn(
          "package(A test case package), copyright()",
          copyrights)


if __name__ == "__main__":
  unittest.main()
