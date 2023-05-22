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
    expected: (dict) map of target name suffixes to the licenses they are under.
    path_prefix: (str) prefix to prepend to targets and licenses in expected.
       This turns the relative target names to absolute ones.
  """

  # Turn the list of deps into a dict by target for easier comparison.
  deps_to_licenses = {
      x["target_under_license"].lstrip("@"): set(l.strip("@") for l in x["licenses"])
      for x in licenses_info[0]["dependencies"]}

  target_names = ",".join(deps_to_licenses.keys())
  # This is n**2, but N is typically < 3 or we are doing this wrong.
  for want_target, want_licenses in expected.items():
    found_target = False
    for got_target, got_licenses in deps_to_licenses.items():
      if got_target.endswith(want_target):
        found_target = True
        test_case.assertEqual(len(want_licenses), len(got_licenses))
        found_license = False
        for want_l in want_licenses:
          for got_l in got_licenses:
            if got_l.endswith(want_l):
              found_license = True
              break
        test_case.assertTrue(
            found_license,
            msg="license (%s) not a suffix in %s" % (want_l, got_licenses))
        break
    test_case.assertTrue(
        found_target,
        msg="target (%s) not a suffix in [%s]" % (want_target, target_names))
