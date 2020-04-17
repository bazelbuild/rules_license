"""Refresh a BUILD file of license_kinds with new ones from licenses.json.

TODO(aiuto): Refine this enought to update BUILD in place.
TODO(aiuto): Add docs
TODO(aiuto): Refer to it from /licenses/spdx/BUILD
"""

import json
from string import Template
import re

def load_json(path):
  """Loads a JSON file and returns the data.

  Args:
    path: (str) a file path.
  Returns:
    (dict) the parsed data.
  """
  with open(path, 'r') as fp:
    ret = json.load(fp)
  return ret


def gather_names(path):
  name_match = re.compile(r'^ *name *= *"([^"]*)"')
  ret = []
  with open(path, 'r') as fp:
    for line in fp:
      m = name_match.match(line)
      if m:
        ret.append(m.group(1))
  return ret

"""
{
  "licenseListVersion": "3.8-57-gca4f142",
  "licenses": [
    {
      "reference": "./0BSD.html",
      "isDeprecatedLicenseId": false,
      "detailsUrl": "http://spdx.org/licenses/0BSD.json",
      "referenceNumber": "232",
      "name": "BSD Zero Clause License",
      "licenseId": "0BSD",
      "seeAlso": [
        "http://landley.net/toybox/license.html"
      ],
      "isOsiApproved": true
    },
"""


def add_new(already_declared, licenses):
  template = Template((
      '\nlicense_kind(\n'
      '    name = "${licenseId}",\n'
      '    conditions = [],\n'
      '    url = "https://spdx.org/licenses/${licenseId}.html",\n'
      ')\n'))

  ret = ''
  for license in licenses:
    if license['licenseId'] in already_declared:
      continue
    ret += template.substitute(license)
  return ret


def main():
  license_json = load_json('licenses.json')
  already_declared = gather_names('../../licenses/spdx/BUILD')
  # print(already_declared)
  new_rules = add_new(already_declared, license_json['licenses'])
  print(new_rules)


if __name__ == '__main__':
  main()
