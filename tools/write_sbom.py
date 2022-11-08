#!/usr/bin/env python3
# Copyright 2020 Google LLC
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

"""Proof of concept license checker.

This is only a demonstration. It will be replaced with other tools.
"""

import argparse
import codecs
import json


def _load_package_data(package_info):
  with codecs.open(package_info, encoding='utf-8') as inp:
    return json.loads(inp.read())


def unique_licenses(licenses):
  for target in licenses:
    for lic in target.get('licenses') or []:
      yield lic

def _write_sbom(out, packages):
  """Produce a basic SBOM

  Args:
    out: file object to write to
    packages: package metadata. A big blob of JSON.
  """
  for p in packages:
    name = p.get('package_name') or '<unknown>'
    if p.get('package_version'):
      name =  name + "/" + p['package_version']
    out.write('# %s\n' % name)
    # IGNORE_COPYRIGHT: Not a copyright notice. It is a variable holding one.
    cn = p.get('copyright_notice')
    if cn:
      out.write('  copyright: %s\n' % cn)
    kinds = p.get('license_kinds')
    if kinds:
      out.write('  license(s): "%s"\n' %
                ','.join([k['name'] for k in kinds]))
    url = p.get('package_url')
    if url:
      out.write('  package URL: %s\n' % url)

  """
  for target in unique_licenses(licenses):
    for lic in target.get('licenses') or []:
      print("lic:", lic)
      rule = lic['rule']
      for kind in lic['license_kinds']:
        out.write('= %s\n  kind: %s\n' % (rule, kind['target']))
        out.write('  conditions: %s\n' % kind['conditions'])
  """

def main():
  parser = argparse.ArgumentParser(
      description='Demonstraton license compliance checker')

  parser.add_argument('--licenses_info',
                      help='path to JSON file containing all license data')
  parser.add_argument('--out', default='sbom.out', help='SBOM output')
  args = parser.parse_args()

  license_data = _load_package_data(args.licenses_info)
  target = license_data[0]  # we assume only one target for the demo

  top_level_target = target['top_level_target']
  dependencies = target['dependencies']
  # It's not really packages, but this is close proxy for now
  licenses = target['licenses']
  packages = target['packages']

  err = 0
  with codecs.open(args.out, mode='w', encoding='utf-8') as rpt:
    _write_sbom(rpt, licenses + packages)
  return err


if __name__ == '__main__':
  main()
