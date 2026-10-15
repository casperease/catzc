---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/Test-ScriptAnalyzer.ps1.md
    kind: comment-page
    body_sha: "71e88757160e"
    adrs:
      - ADR-AUTO-ASSETDEP#1
      - ADR-AUTO-NOPWD#1
---

# automation/Catzc.Base.QualityGates/Test-ScriptAnalyzer.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:8

Above `$settingsPath = Join-Path (Get-CatzcModulesRoot)...`.

```text
The one settings file ships inside the code tree, so it resolves from the code root
([ADR-AUTO-ASSETDEP#1](/docs/adr/automation/internal-asset-dependencies.md#rule-adr-auto-assetdep1)).
```

## comment:9

Above `$files = [System.Collections.Generic.List[string]]::new()`.

```text
Resolve the file set — same coverage as the L2 analyzer test (module root
*.ps1 non-test, private/, tests/ *.Tests.ps1, and the .internal/.scriptanalyzer infrastructure folders).
```

## comment:10

Above `$full = if ([System.IO.Path]::IsPathRooted($item)) {`.

```text
A relative path is repository-relative, never $PWD-relative
([ADR-AUTO-NOPWD#1](/docs/adr/automation/never-depend-on-pwd.md#rule-adr-auto-nopwd1)).
```

## comment:11

Above `foreach ($f in (Get-AutomationSourceFiles)) {`.

```text
The canonical checked set — shared with the L2 analyzer test so they cannot
drift. Includes the root importer.ps1 and authored .psd1 config; excludes generated manifests.
```

## comment:12

Above `Write-Message "Analyzing $($files.Count) PowerShell file(s) with...`.

```text
Analyze, sharded across background processes with live progress (Get-ScriptAnalyzerDiagnostics) — a
serial pass is ~90s of silence and reads as a hang. The upfront message confirms work has started.
```
