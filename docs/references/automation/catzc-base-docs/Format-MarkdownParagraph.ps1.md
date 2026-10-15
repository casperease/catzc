---
catzc:
  derived:
    path: docs/references/automation/catzc-base-docs/Format-MarkdownParagraph.ps1.md
    kind: comment-page
    body_sha: bfad51b4ad62
    adrs:
      - ADR-REPO-FORMAT#5
---

# automation/Catzc.Base.Docs/Format-MarkdownParagraph.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Greedy fill — each line takes as many words as fit in Width columns, prefix included — which is what Prettier's
`proseWrap: always` produces, so generated markdown (the ADR index, the glossary, the contract reference) is
formatter-stable ([ADR-REPO-FORMAT#5](/docs/adr/repository/uniform-formatting.md#rule-adr-repo-format5)). The first
line carries FirstPrefix (a list marker such as '- '), every later line ContinuationPrefix (the marker's indent).

Prettier never breaks inside an inline code span or a link, so a `code span` and a [text](target) link each count
as part of one unbreakable word, spaces included. A word longer than the width stays whole on its own line.
```
