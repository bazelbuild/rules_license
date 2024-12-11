#!/usr/bin/env python3
"""Refresh the BUILD file of SPDX license_kinds with new ones from licenses.json.

Usage:
  wget https://raw.githubusercontent.com/spdx/license-list-data/main/json/licenses.json
  LC_ALL="en_US.UTF-8" admin/refresh_spdx/add_licenses.py
  git diff
  git commit
"""

import json
import os
from string import Template
import re
import sys
import urllib.request


def load_json(path: str):
    """Loads a JSON file and returns the data.

    Args:
      path: (str) a file path.
    Returns:
      (dict) the parsed data.
    """
    with open(path, "r") as fp:
        ret = json.load(fp)
    return ret


def parse_build_file(text: str):
    """Parse a BUILD file of license declaration.

    Parses a build file and returns all the text that
    is not licenese_kind declarations and a map of
    license kind names to the text which declared them

    license_kind(
      name = "0BSD",
      conditions = [],
      url = "https://spdx.org/licenses/0BSD.html",
    )

    Returns:
      preamble: str
      targets: map<str, str>
    """

    target_start = re.compile(r"^([a-zA-Z0-9_]+)\(")  # ) to fix autoindent
    name_match = re.compile(r'^ *name *= *"([^"]*)"')

    targets = {}
    preamble = []
    collecting_rule = None

    for line in text.split("\n"):
        if collecting_rule:
            collecting_rule.append(line)
            if line.startswith(")"):
                assert cur_name
                targets[cur_name] = "\n".join(collecting_rule)
                # print(cur_name, "=====", targets[cur_name])
                collecting_rule = None
                cur_name = None
            else:
                m = name_match.match(line)
                if m:
                    cur_name = m.group(1)
            continue

        # not collecting a rule
        m = target_start.match(line)
        if m:
            cur_rule = m.group(1)
            if cur_rule == "license_kind":
                collecting_rule = [line]
                continue

        if line or preamble[-1]:
            preamble.append(line)

    return "\n".join(preamble), targets


# Sample JSON formate license declaration.
"""
{
  "licenseListVersion": "d2ce3b6",
  "licenses": [
    {
      "reference": "https://spdx.org/licenses/0BSD.html",
      "isDeprecatedLicenseId": false,
      "detailsUrl": "https://spdx.org/licenses/0BSD.json",
      "referenceNumber": 16,
      "name": "BSD Zero Clause License",
      "licenseId": "0BSD",
      "seeAlso": [
        "http://landley.net/toybox/license.html",
        "https://opensource.org/licenses/0BSD"
      ],
      "isOsiApproved": true
    },
"""


def insert_new(already_declared, licenses):
    template = Template(
        (
            "license_kind(\n"
            '    name = "${licenseId}",\n'
            "    conditions = [],\n"
            '    url = "${reference}",\n'
            ")"
        )
    )

    for license in licenses:
        id = license["licenseId"]
        old = already_declared.get(id)
        if not old:
            print("Adding:", id)
            already_declared[id] = template.substitute(license)


def get_license_json():
    url = "https://raw.githubusercontent.com/spdx/license-list-data/refs/heads/main/json/licenses.json"
    return json.loads(urllib.request.urlopen(url).read())

def update_spdx_build():
    """Update //licenses/spdx/BUILD with new license kinds."""

    license_json = get_license_json()

    # Find workspace root
    build_path = "licenses/spdx/BUILD"
    docs_path = "docs/license_kinds.md"
    found_spdx_build = False
    for i in range(5):  # Simple regression failure limiter
        if os.access("WORKSPACE", os.R_OK) and os.access(build_path, os.R_OK):
            found_spdx_build = True
            break
        os.chdir("..")
    if not found_spdx_build:
        print("Could not find", build_path)
        return 1

    with open(build_path, "r") as fp:
        current_file_content = fp.read()

    preamble, kinds = parse_build_file(current_file_content)
    insert_new(kinds, license_json["licenses"])
    with open(build_path, "w") as fp:
        fp.write(preamble)
        for license in sorted(kinds.keys(), key=lambda x: x.lower()):
            fp.write("\n")
            fp.write(kinds[license])
            fp.write("\n")

    with open(docs_path, "w") as f:
        f.write("# SPDX License Kinds\n\n")
        licenses = license_json["licenses"]
        f.write("| License Name | Target Label | Reference |\n")
        f.write("|--------------|--------------|-----------|\n")
        for license in sorted(licenses, key=lambda x: x["name"].lower()):
            f.write(f"| {license['name']} | `@rules_license//licenses/spdx:{license['licenseId']}` | [reference]({license['reference']}) |\n")



def main():
    lc_all = os.environ.get("LC_ALL")
    if lc_all != "en_US.UTF-8":
        print("Your environment settings will reorder the file badly.")
        print("Please rerun as:")
        print('  LC_ALL="en_US.UTF-8"', " ".join(sys.argv))
        sys.exit(1)

    update_spdx_build()


if __name__ == "__main__":
    main()
