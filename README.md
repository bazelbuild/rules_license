# rules_license

CI: [![Build status](https://badge.buildkite.com/e12f23186aa579f1e20fcb612a22cd799239c3134bc38e1aff.svg)](https://buildkite.com/bazel/rules-license)

| :warning: WARNING           |
|:----------------------------|
| Active development has moved to https://github.com/bazel-contrib/supply-chain.  Please look there for current status. If you wish to contribute, please consider doing your work there. |

:warning: WARNING
Version 2.0.0 of this package is version 1 with the addition of providers
that are compatible with `supply-chain`. This provides a slow migration
path where you can use supply-chain tools to reason about your project,
while still incorporating projects using rules_license.


This repository contains a set of rules and tools for
- declaring metadata about packages, such as
  - the licenses the package is available under
  - the canonical package name and version
  - copyright information
  - ... and more TBD in the future
- gathering license declarations into artifacts to ship with code
- applying organization specific compliance constraints against the
  set of packages used by a target.
- producing SBOMs for built artifacts.


## Background reading:

These is for learning about the problem space, and our approach to solutions. Concrete specifications will always appear in checked in code rather than documents.
- [License Checking with Bazel](https://docs.google.com/document/d/1uwBuhAoBNrw8tmFs-NxlssI6VRolidGYdYqagLqHWt8/edit#).
- [OSS Licenses and Bazel Dependency Management](https://docs.google.com/document/d/1oY53dQ0pOPEbEvIvQ3TvHcFKClkimlF9AtN89EPiVJU/edit#)
- [Adding OSS license declarations to Bazel](https://docs.google.com/document/d/1XszGbpMYNHk_FGRxKJ9IXW10KxMPdQpF5wWbZFpA4C8/edit#heading=h.5mcn15i0e1ch)
