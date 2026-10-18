---
catzc:
  immutable:
    with_body_sha: ef90cd38beeb
    repo_status: locked
    path: docs/references/automation/catzc-base-qualitygates/private/Invoke-PSScriptAnalyzerFormat.ps1.md
    folder: docs/references/automation/catzc-base-qualitygates/private
    name: invoke-ps-script-analyzer-format-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    tracktype: documentation
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
  edges:
    cites:
      - ADR-AUTO-CONSOLE#10
---

# automation/Catzc.Base.QualityGates/private/Invoke-PSScriptAnalyzerFormat.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

The psscriptanalyzer formatter engine: formats the given PowerShell files with the vendored analyzer's
Invoke-Formatter and the .editorconfig rules, and returns the files it changed.

### description

One Format-Code engine adapter ([ADR-PRIN-CONFIG#2](../../../../adr/principles/configure-not-program.md#rule-adr-prin-config2)).
Two steps per file, the same two VS Code's Format Document and save apply:

1. Invoke-Formatter with the repository's one analyzer settings file — brace placement, indentation, whitespace,
   and hashtable alignment (the codeFormatting settings in vscode-settings.yml mirror the same rules);
2. the .editorconfig rules Invoke-Formatter does not read — LF line endings, no trailing whitespace, one final
   newline ([ADR-REPO-FORMAT#3](../../../../adr/repository/uniform-formatting.md#rule-adr-repo-format3)).

A file is written back as UTF-8 without a BOM only when the result differs, compared case-sensitively so a
casing-only change counts. The vendored analyzer and its settings ship in the code tree, so both resolve from
the code root ([ADR-AUTO-ASSETDEP#1](../../../../adr/automation/internal-asset-dependencies.md#rule-adr-auto-assetdep1));
the first use in a session imports the analyzer, which takes seconds and is announced.

### parameter File

Absolute paths of the PowerShell files to format.

### parameter DryRun

List the files that would change without writing them.

### outputs

`[string[]]` Absolute paths of the files changed (or, under -DryRun, that would change).

## comment:1

Above `$shardCount = [Math]::Min([Math]::Max(1,...`, written with `#`.

```text
A cold pass spends about 40 ms a file resolving command names it has not seen, so a large batch is sharded
across a few processes (the analyzer's initialization is not thread-safe, as in Get-ScriptAnalyzerDiagnostics);
a small batch, the usual warm-cache one, stays in this session.
```

## comment:2

Above `Write-Message 'Loading PSScriptAnalyzer (first use this session)...'`, written with `#`.

```text
First use this session pays the vendored-module import (several seconds) — announce it
([ADR-AUTO-CONSOLE#10](/docs/adr/automation/console-output-matters.md#rule-adr-auto-console10)).
```
