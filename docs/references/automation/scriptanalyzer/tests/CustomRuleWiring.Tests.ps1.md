# automation/.scriptanalyzer/tests/CustomRuleWiring.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `[Diagnostics.CodeAnalysis.SuppressMessageAttribute('Measure-NoRawVsoCommand',...`, written with `#`.

```text
Shared wiring check for the repo's AST-direct custom rules. Each check's per-case behaviour is proven at L0 by
calling its Measure-* function directly (see the sibling <Rule>.Tests.ps1 files); the one thing those L0 tests
cannot prove is that PSScriptAnalyzer loads the settings' one entry rule (CatzcRules.psm1) and surfaces each check's
diagnostic, under the check's own rule name, when a real violation is present. That end-to-end fact is identical
for every check, so one invocation over a single fixture that trips all of them proves it once — rather than paying
the engine warmup per check.

The fixture embeds a raw ##vso[task.*] string (to trip Measure-NoRawVsoCommand), which that rule would then
flag against this file during Test-ScriptAnalyzer — suppress it for the whole file, as the rule's own test
file does.
```

## comment:2

Above `$script:analyzerSettings = @{ CustomRulePath = [string[]] $script:rulePaths;...`, written with `#`.

```text
Explicit settings: without them the engine also discovers the generated root PSScriptAnalyzerSettings.psd1
from the working directory and loads its custom rules a second time, doubling every record.
```

## comment:3

Above ``$longBody = (1..301 | ForEach-Object { '    $null = 1' }) -join "`n"``, written with `#`.

```text
One fixture that trips every check at once: an Az-named function nested in another function, a raw
Write-Information, a direct pipeline-detection env read, a raw ##vso command written with Write-Host (a raw
console write), an unannounced env change, a coined variable name, a first-element index of a collected
result, a bare lazy $script: read, a $PWD read, Write-Error, $?, a PascalCase local, return inside
ForEach-Object, and a function body over 300 lines. NoScriptRootAnchor applies only to a module file path, so
an in-memory definition cannot trip it; its own tests cover it.
```
