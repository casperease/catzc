---
catzc:
  derived:
    path: docs/references/automation/catzc-base-docs/private/Get-GlossaryAnchorViolations.ps1.md
    kind: comment-page
    body_sha: "2e776c9942e7"
    adrs:
      - ADR-REPO-VOCAB#1
---

# automation/Catzc.Base.Docs/private/Get-GlossaryAnchorViolations.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
A defined term has one home: the ADR rule its concept names in `defined_by`, whose normative summary bolds it
([ADR-REPO-VOCAB#1](/docs/adr/repository/controlled-vocabulary.md#rule-adr-repo-vocab1)). For every concept whose
source takes part in
the `anchored` check, this reports:
  - a `defined_by` citation that names no rule of any indexed ADR;
  - a defining rule whose normative summary does not contain `**<term>**` (case-insensitive, whitespace
    collapsed, so a term bolded across a wrapped line still counts).
Only the normative summary counts (Get-CatsAdrRules' Statement): bold text in the ADR body or in the rule's
linked bullets never anchors a term, and neither does a mention inside an inline code span.

Private helper for the glossary checks; not exported.
```

## comment:2

Section `.PARAMETER IndexPath` of the comment-based help.

```text
Absolute path to the ADR index whose ADRs hold the rules. Defaults to
[index](/docs/adr/index.md); a test points it at
a fixture index beside fixture ADR files.
```
