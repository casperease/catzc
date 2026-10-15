---
catzc:
  derived:
    path: docs/references/automation/catzc-base-docs/private/Get-GlossaryRuleStatements.ps1.md
    kind: comment-page
    body_sha: "6d7c9b00446c"
    adrs:
      - ADR-REPO-VOCAB#1
      - ADR-REPO-VOCAB#5
    links: []
---

# automation/Catzc.Base.Docs/private/Get-GlossaryRuleStatements.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Walks the ADRs the index lists (Get-CatsAdrIndex) and reads each one's rules (Get-CatsAdrRules), keeping each
rule's Statement — its whole normative summary on one line — with inline code spans removed. A code span is a
mention, never a definition
([ADR-REPO-VOCAB#5](/docs/adr/repository/controlled-vocabulary.md#rule-adr-repo-vocab5)), so `A **<term>** is …`
written in backticks neither anchors nor
defines a term. This is the one text the anchoring (G2) and single-definition (G3) checks match against
([ADR-REPO-VOCAB#1](/docs/adr/repository/controlled-vocabulary.md#rule-adr-repo-vocab1)); ADR bodies are never read.

Private helper for the glossary checks; not exported.
```

## comment:2

Section `.PARAMETER IndexPath` of the comment-based help.

```text
Absolute path to the ADR index. ADR paths in it resolve against the index's own folder, so a test can point
this at a fixture index beside fixture ADR files.
```
