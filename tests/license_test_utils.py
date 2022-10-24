"""Utilities for writing tests of license rules."""

import codecs
import json


# This is extracted out to make it easier to keep test equivalence between
# the OSS version and Google.
LICENSE_PACKAGE_BASE = "/"


def load_licenses_info(info_path):
  """Loads the licenses_info() JSON format."""
  with codecs.open(info_path, encoding="utf-8") as licenses_file:
    return json.loads(licenses_file.read())


def filter_dependencies(licenses_info, target_filter=None,
                        licenses_filter=None):
  """Filters licenses_info to only include dependencies of interest.

  Args:
    licenses_info: (dict) licenses info.
    target_filter: (function): function which returns true if we should include
        the target.
    licenses_filter: (function): function which returns true if we should
        include the license.
  Returns:
    (dict) a valid licenses_info dict.
  """
  top_target = licenses_info[0]
  new_top_target = dict(top_target)
  new_deps = []
  for dep in top_target["dependencies"]:
    target_name = dep["target_under_license"]
    if target_filter and not target_filter(target_name):
      continue
    licenses = dep["licenses"]
    if licenses_filter:
      licenses = [lic for lic in licenses if licenses_filter(lic)]
    new_deps.append({
        "target_under_license": target_name,
        "licenses": licenses})
  new_top_target["dependencies"] = new_deps
  return [new_top_target]


def check_licenses_of_dependencies(test_case, licenses_info, expected,
                                   path_prefix=LICENSE_PACKAGE_BASE):
  """Checks that licenses_info contains an expected set of licenses.

  Args:
    test_case: (TestCase) the test.
    licenses_info: (dict) licenses info.
    expected: (dict) map of target names to the licenses they are under. Names
        must be relative to the licenses package, not absolute.
    path_prefix: (str) prefix to prepend to targets and licenses in expected.
       This turns the relative target names to absolute ones.
  """

  # Turn the list of deps into a dict by target for easier comparison.
  print(licenses_info)
  deps_to_licenses = {
      x["target_under_license"].lstrip('@'): set(l.strip('@') for l in x["licenses"])
      for x in licenses_info[0]["dependencies"]}
  print(deps_to_licenses)

  for target, licenses in expected.items():
    got_licenses = set(deps_to_licenses[path_prefix + target])
    for lic in licenses:
      test_case.assertIn(path_prefix + lic, got_licenses)
  # future: Maybe check that deps is not larger than expected.
