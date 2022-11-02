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
"""A trivial tool to turn a string into a C++ constant.

This is not meant to be useful. It is only to provide an example of a tool that
generates code.
"""

import sys


def main(argv):
  if len(argv) != 4:
    raise Exception('usage: constant_generator out_file var_name text')
  with open(argv[1], 'w') as out:
    out.write('const char* %s = "%s";\n' % (argv[2], argv[3]))


if __name__ == '__main__':
  main(sys.argv)
