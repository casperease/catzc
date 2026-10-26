# pwsh/Base.FileLimits/tests/Build-WidthConfigs.Tests.ps1

The tests of `Build-WidthConfigs`, which renders the width-bearing tool configs from `file-limits.yml`.

## What it proves

The widths are rendered from `file-limits.yml`, so the tests pin them to the formatters' widths from before the declared widths existed.
