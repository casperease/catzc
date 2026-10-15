---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/private/Get-EngineSetFinding.ps1.md
    kind: reference
    body_sha: eb3a3b74e052
    adrs:
      - ADR-AUTO-ENGINE#1
---

# automation/Catzc.Base.QualityGates/private/Get-EngineSetFinding.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
The engine-set check of Test-SourceConventions
([ADR-AUTO-ENGINE#1](/docs/adr/automation/execution-engines.md#rule-adr-auto-engine1)): the execution engines are
declared once, in [Catzc.Base.Engines.ExecutionEngines], and every other list is read from it. The engine names
and their count come from the caller, read from that model, so nothing here names an engine.

In prose — a markdown file's text, and the comments (help included) of a code file (CommentLexer) — a phrase from
engine_set's count_phrases or name_phrases that miscounts the engines or names some but not all of them
(EngineSetCheck.FindProse). In code:
  - PowerShell (from its syntax tree): a ValidateSet, an array literal, or a switch with no default whose string
    values name two or more engines;
  - C#: two or more engine names as string literals on one line (EngineSetCheck.FindCSharpLists).
```
