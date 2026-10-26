# pwsh/.scriptanalyzer/tests/CustomRuleWiring.Tests.ps1

The one engine-wiring test (L2) shared by the repository's AST-direct custom rules.

## What it proves

Each check's per-case behaviour is proven at L0 by calling its `Measure-*` function directly (see the sibling `<Rule>.Tests.ps1` files).
The one thing those tests cannot prove is that PSScriptAnalyzer loads the settings' one entry rule (`CatzcRules.psm1`) and surfaces each
check's diagnostic, under the check's own rule name, when a real violation is present. That end-to-end fact is identical for every check,
so one invocation over a single fixture that trips all of them proves it once, rather than paying the engine warmup per check.

## The fixture

The fixture trips every check at once:

- an Az-named function nested in another function,
- a raw `Write-Information`,
- a direct pipeline-detection environment read,
- a raw `##vso` command written with `Write-Host` (also a raw console write),
- an unannounced environment change,
- a coined variable name,
- a first-element index of a collected result,
- a bare lazy `$script:` read,
- a `$PWD` read,
- `Write-Error`,
- `$?`,
- a PascalCase local,
- `return` inside `ForEach-Object`,
- a function body over the configured length limit.

`NoScriptRootAnchor` applies only to a module file path, so an in-memory definition cannot trip it; its own tests cover it.

The fixture embeds a raw `##vso[task.*]` string, which `Measure-NoRawVsoCommand` would flag against this file during
`Test-ScriptAnalyzer`. The file suppresses that rule for the whole file, as the rule's own test file does.

## Explicit settings

The run passes explicit settings. Without them the engine also discovers the generated root `PSScriptAnalyzerSettings.psd1` from the
working directory and loads its custom rules a second time, doubling every record.
