# pwsh/Base.Objects/tests/ConvertTo-FlatSettingSet.Tests.ps1

The L0 logic tests of `ConvertTo-FlatSettingSet`.

## Typed fixtures

The reflect-over-public-members path is proved with real CLR types that are PowerShell classes, with a nested typed member. PowerShell parses
them without a Roslyn compile, which avoids `Add-Type`, whose compile was the entire cost of this file.
