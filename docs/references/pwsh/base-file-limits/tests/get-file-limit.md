# pwsh/Base.FileLimits/tests/Get-FileLimit.Tests.ps1

The tests of `Get-FileLimit`, which resolves a file's limits from the file-limits config.

## What it proves

A file's limits come from its language in the one registry, so a file no language declares fails instead of escaping unlimited.
