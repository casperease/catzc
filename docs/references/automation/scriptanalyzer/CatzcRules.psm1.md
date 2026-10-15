---
catzc:
  derived:
    path: docs/references/automation/scriptanalyzer/CatzcRules.psm1.md
    kind: comment-page
    body_sha: fcfaf4a5a410
    adrs: []
---

# automation/.scriptanalyzer/CatzcRules.psm1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `$script:measures = $null`.

```text
The check modules' Measure-* functions, loaded on the first root block (see Measure-CatzcRules); declared at load so
the guard reads it strict-clean.
```

## comment:2

Section `.DESCRIPTION` of the comment-based help.

```text
PSScriptAnalyzer calls a script rule once for every ScriptBlockAst in a file (the file, each function body, each
script block literal) and pays a fixed cost per call, even for a rule that does nothing. This entry rule acts only
on the file's root block and hands it to each check, so every check runs once per file and walks the whole tree
from there.

The engine loads this module far more often than it hands it a root block (measured: 404 loads for 124 files),
and loading the check modules costs ~65 ms per load — ~4x the checks' own run time. So the checks load lazily,
on the first root block a loaded copy of this module sees, never at module load.

Each check lives in its own module next to this one, with its own tests, and keeps its own RuleName on the records
it emits. Diagnostics, SuppressMessageAttribute('Measure-<Check>', …) and analyzer-adr-map.yml all name the check,
never this entry rule. Add a new check module to $checks above (every Measure-* function it exports runs); the
engine-wiring test (CustomRuleWiring.Tests.ps1) proves each check fires through the engine.
```

## comment:3

Above `if ($null -eq $script:measures) {`.

```text
Each check module loads nested in this one, so its Measure-* functions are visible here but not exported to the
engine. A module may export more than one check.
```
