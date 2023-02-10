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
"""Tests for license/examples/src."""

import os

import unittest
from tests import license_test_utils


class ServerLicensesTest(unittest.TestCase):

  def test_has_expected_licenses(self):
    package_base = license_test_utils.LICENSE_PACKAGE_BASE
    licenses_info = license_test_utils.load_licenses_info(
        os.path.join(os.path.dirname(__file__), "server_licenses.json"))
    licenses_info = license_test_utils.filter_dependencies(
        licenses_info,
        target_filter=lambda targ: targ.startswith(package_base),
        licenses_filter=lambda lic: lic.startswith(package_base))

    expected = {
        "/examples/src:message_src_": [
            "/examples/vndor/constant_gen:license_for_emitted_code"
        ],
        "/examples/src:message": [
            "/examples/vndor/constant_gen:license_for_emitted_code"
        ],
    }
    license_test_utils.check_licenses_of_dependencies(
        self, licenses_info, expected)


if __name__ == "__main__":
  unittest.main()
