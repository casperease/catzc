---
catzc:
  derived:
    path: docs/references/automation/catzc-base-docs/private/Get-CatsAdrRules.ps1.md
    kind: comment-page
    body_sha: "3e9e29a570ed"
    adrs:
      - ADR-REPO-VOCAB#1
    links: []
---

# automation/Catzc.Base.Docs/private/Get-CatsAdrRules.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Reads an ADR markdown file and returns one entry per `### Rule <CODE>:<n>` heading: the rule id, the
first non-empty line of its body (Summary, the one-liner Show-Cats lists), and the whole first paragraph
of its body joined into one line (Statement). The blank-line-padding authoring convention
([index](/docs/adr/index.md))
makes that paragraph the rule's normative summary, ending at the blank line before its linked bullets, so
Statement never includes them. The glossary checks read Statement: a term bolded on a wrapped line still
belongs to the rule ([ADR-REPO-VOCAB#1](/docs/adr/repository/controlled-vocabulary.md#rule-adr-repo-vocab1)).

Private helper for Show-Cats and the glossary checks; not exported.
```
