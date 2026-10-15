---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/tests/Test-MarkdownTitle.Repository.Tests.ps1.md
    kind: test-asset
    body_sha: "176db519e3da"
    adrs:
      - ADR-REPO-FORMAT#6
---

# automation/Catzc.Base.QualityGates/tests/Test-MarkdownTitle.Repository.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per
section (Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `Describe 'Repository Markdown titles' -Tag 'L1', 'integrity', 'source-only' {`.

```text
The real repository titles every in-scope Markdown file with its path
([ADR-REPO-FORMAT#6](/docs/adr/repository/uniform-formatting.md#rule-adr-repo-format6)). An integrity check over the tracked tree.
```
