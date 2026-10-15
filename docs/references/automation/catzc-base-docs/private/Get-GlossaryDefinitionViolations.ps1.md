---
catzc:
  derived:
    path: docs/references/automation/catzc-base-docs/private/Get-GlossaryDefinitionViolations.ps1.md
    kind: comment-page
    body_sha: "9bab23e76776"
    adrs:
      - ADR-REPO-VOCAB#1
    links: []
---

# automation/Catzc.Base.Docs/private/Get-GlossaryDefinitionViolations.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
A defined term is fixed by exactly one rule
([ADR-REPO-VOCAB#1](/docs/adr/repository/controlled-vocabulary.md#rule-adr-repo-vocab1)).
For every concept whose source takes part in the `single` check, this reports each rule other than its
`defined_by` whose normative summary defines the term again: `**<term>** is` (case-insensitive, whitespace
collapsed). The pattern is deliberately conservative — a rule that merely bolds the term is not a definition —
and only normative summaries count (Get-GlossaryRuleStatements): bold text in an ADR body or inside an inline
code span never does.

Private helper for the glossary checks; not exported.
```

## comment:2

Section `.PARAMETER IndexPath` of the comment-based help.

```text
Absolute path to the ADR index whose ADRs hold the rules. Defaults to
[index](/docs/adr/index.md); a test points it at
a fixture index beside fixture ADR files.
```
