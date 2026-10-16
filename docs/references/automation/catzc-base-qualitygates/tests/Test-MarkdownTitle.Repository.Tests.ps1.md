---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/tests/Test-MarkdownTitle.Repository.Tests.ps1.md
    kind: comment-page
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: a855d34cd38a
    adrs:
      - ADR-REPO-FORMAT#6
---

# automation/Catzc.Base.QualityGates/tests/Test-MarkdownTitle.Repository.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'Repository Markdown titles' -Tag 'L1', 'integrity', 'source-only' {`, written with `#`.

```text
The real repository titles every in-scope Markdown file with its path
([ADR-REPO-FORMAT#6](/docs/adr/repository/uniform-formatting.md#rule-adr-repo-format6)). An integrity check over the tracked tree.
```
