---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/Test-Formatting.ps1.md
    kind: comment-page
    body_sha: "9e68ef2cd274"
    adrs:
      - ADR-AUTO-TEST#35
      - ADR-PRIN-CONFIG#1
---

# automation/Catzc.Base.QualityGates/Test-Formatting.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
One gate for every formatter's check ([ADR-AUTO-TEST#35](/docs/adr/automation/test-automation.md#rule-adr-auto-test35)).
It keeps no list of formatters of its own: Format-Code -DryRun runs every engine the file-language registry
(languages.yml) names, over every tracked file of each language, and every file an engine would change is one
issue naming the file and the command that fixes it
([ADR-PRIN-CONFIG#1](/docs/adr/principles/configure-not-program.md#rule-adr-prin-config1)).

The C# file-scoped namespace is a repository content rule rather than a layout engine, so it is checked beside
the engines: Format-Types -DryRun names every type source whose namespace is missing or wrong, and every
block-scoped one, which needs a hand edit. It runs with the csharp language — on the full run, or when -Language
names csharp.

Collects every issue and ends with Write-QualityGateReport: the report lands in out/test-formatting/, and the gate
throws once listing every issue (or returns the result with -PassThru). An engine whose tool is missing throws
with the command that installs it. The scope is the source tree, so the gate needs the source mode
(Assert-SourceTree).
```
