# Copyright 2022 The Bazel Authors. All rights reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
"""The version of rules_license."""

# This is automagically replace by git during git archive using `git export-subst`
# See https://git-scm.com/docs/git-archive/2.29.0#Documentation/git-archive.txt-export-subst
_VERSION_PRIVATE = "$Format:%(describe:tags=true)$"

# When using rules_license from source rather than from a release artifact, export a placeholder value
version = "0.0.0-unreleased" if _VERSION_PRIVATE.startswith("$Format") else _VERSION_PRIVATE
