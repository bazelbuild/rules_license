#!/usr/bin/env python3
import argparse
import codecs
import json


def main():
  parser = argparse.ArgumentParser(
      description='Demonstraton license compliance checker')

  parser.add_argument('--licenses_in', help='path to JSON file containing all license info')
  parser.add_argument('--licenses_out', help='path to JSON file where augmented license info should be stored')
  args = parser.parse_args()

  with codecs.open(args.licenses_in, encoding='utf-8') as inp:
    license_data = json.loads(inp.read())
  
  for target in license_data:
    for license in target['licenses']:
      license_path = license.get('license_text')
      if license_path:
        with codecs.open(license_path, encoding='utf-8') as license_file:
          license['license_text'] = license_file.read()

  with codecs.open(args.licenses_out, mode='w', encoding='utf-8') as out:
    json.dump(license_data, out, indent=4)


if __name__ == '__main__':
  main()
