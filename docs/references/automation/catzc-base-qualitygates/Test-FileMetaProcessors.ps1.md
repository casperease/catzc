---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/Test-FileMetaProcessors.ps1.md
    kind: comment-page
    body_sha: eff78d97f7ca
    adrs:
      - ADR-AUTO-TEST#35
---

# automation/Catzc.Base.QualityGates/Test-FileMetaProcessors.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
A kind whose function is missing fails the run that reads the registry, and a function no kind names is never called, so this gate
lists both orphans. A function is a processor candidate when it is named Get-<Kind>FileMetaFact or
Get-<Kind>MarkdownConfigContribution.
[ADR-AUTO-TEST#35](/docs/adr/automation/test-automation.md#rule-adr-auto-test35)
```
