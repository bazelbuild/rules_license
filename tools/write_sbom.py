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
import datetime
import json
import os


TOOL = 'https//github.com/bazelbuild/rules_license/tools:write_sbom'

def _load_package_data(package_info):
  with codecs.open(package_info, encoding='utf-8') as inp:
    return json.loads(inp.read())

def _write_sbom_header(out, package):
  header = [
    'SPDXVersion: SPDX-2.2',
    'DataLicense: CC0-1.0',
    'SPDXID: SPDXRef-DOCUMENT',
    'DocumentName: %s' % package,
    # TBD
    # 'DocumentNamespace: https://swinslow.net/spdx-examples/example1/hello-v3
    'Creator: Person: %s' % os.getlogin(),
    'Creator: Tool: %s' % TOOL,
    datetime.datetime.utcnow().strftime('Created: %Y-%m-%d-%H:%M:%SZ'),
    '',
    '##### Package: %s' % package,
  ]
  out.write('\n'.join(header))



def _write_sbom(out, packages):
  """Produce a basic SBOM

  Args:
    out: file object to write to
    packages: package metadata. A big blob of JSON.
  """
  for p in packages:
    name = p.get('package_name') or '<unknown>'
    out.write('\n')
    out.write('SPDXID: "%s"\n' % name)
    out.write('  name: "%s"\n' % name)
    if p.get('package_version'):
      out.write('  versionInfo: "%s"\n' % p['package_version'])
    # IGNORE_COPYRIGHT: Not a copyright notice. It is a variable holding one.
    cn = p.get('copyright_notice')
    if cn:
      out.write('  copyrightText: "%s"\n' % cn)
    kinds = p.get('license_kinds')
    if kinds:
      out.write('  licenseDeclared: "%s"\n' %
                ','.join([k['name'] for k in kinds]))
    url = p.get('package_url')
    if url:
      out.write('  downloadLocation: %s\n' % url)


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
  package_infos = target['packages']

  # These are similar dicts, so merge them by package. This is not
  # strictly true, as different licenese can appear in the same
  # package, but it is good enough for demonstrating the sbom.

  all = {x['bazel_package']: x for x in licenses}
  for pi in package_infos:
    p = all.get(pi['bazel_package'])
    if p:
      p.update(pi)
    else:
      all[pi['bazel_package']] = pi

  err = 0
  with codecs.open(args.out, mode='w', encoding='utf-8') as out:
    _write_sbom_header(out, package=top_level_target)
    _write_sbom(out, all.values())
  return err


if __name__ == '__main__':
  main()
