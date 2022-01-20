#!/usr/bin/env python3
"""Refresh a BUILD file of license_kinds with new ones from licenses.json.

Usage:
  wget https://github.com/spdx/license-list-data/raw/master/json/licenses.json
  python add_licenses.py
  git diff
  git commit
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


def gather_target_names(text):
  name_match = re.compile(r'^ *name *= *"([^"]*)"')
  ret = []
  for line in text.split('\n'):
    m = name_match.match(line)
    if m:
      ret.append(m.group(1))
  return ret



# Sample JSON formate license declaration.
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


def update_spdx_build():
  """Update //licenses/spdx/BUILD with new license kinds."""

  build_path = '../../licenses/spdx/BUILD'
  with open(build_path, 'r') as fp:
    current_file_content = fp.read()
  already_declared = gather_target_names(current_file_content)

  license_json = load_json('licenses.json')
  new_rules = add_new(already_declared, license_json['licenses'])
  with open(build_path, 'w') as fp:
    fp.write(current_file_content)
    fp.write(new_rules)


def main():
  update_spdx_build()


if __name__ == '__main__':
  main()
