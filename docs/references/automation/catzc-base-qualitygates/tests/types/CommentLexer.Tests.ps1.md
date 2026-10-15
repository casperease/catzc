---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/tests/types/CommentLexer.Tests.ps1.md
    kind: test-asset
    body_sha: "32a11feba88f"
    adrs:
      - ADR-REPO-LINK#1
      - ADR-REPO-LINK#6
---

# automation/Catzc.Base.QualityGates/tests/types/CommentLexer.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `Describe 'CommentLexer' -Tag 'L0', 'logic' {`.

```text
CommentLexer finds the comment spans a code link may live in
([ADR-REPO-LINK#1](/docs/adr/repository/markdown-links.md#rule-adr-repo-link1)) and must never mistake a string for
one ([ADR-REPO-LINK#6](/docs/adr/repository/markdown-links.md#rule-adr-repo-link6)). Each case asserts the comment
texts found in a short widget/gadget snippet.
```
