# pwsh/Base.FileLimits/tests/types/FileLimitsConfig.Tests.ps1

The tests of the `FileLimitsConfig` type, the typed record of `file-limits.yml`.

## What it proves

The type is the only place a file-limits default lives, and its bounds are asserted on construction, so a wrong number never reaches a gate.
