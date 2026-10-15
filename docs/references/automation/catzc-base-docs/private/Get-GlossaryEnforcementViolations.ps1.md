---
catzc:
  derived:
    path: docs/references/automation/catzc-base-docs/private/Get-GlossaryEnforcementViolations.ps1.md
    kind: comment-page
    body_sha: f19fef4fb5f6
    adrs:
      - ADR-REPO-VOCAB#6
    links: []
---

# automation/Catzc.Base.Docs/private/Get-GlossaryEnforcementViolations.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
A concept realized in code is only as reliable as the check behind it
([ADR-REPO-VOCAB](/docs/adr/repository/controlled-vocabulary.md),
[ADR-REPO-VOCAB#6](/docs/adr/repository/controlled-vocabulary.md#rule-adr-repo-vocab6)). For every concept whose
source takes part in the `enforced` check and whose `realized_by.kind`
is not `prose-only`, this reports a defining rule (`defined_by`) with no enforcer: no analyzer rule mapped to it
and no test citing it in a `-Tag` — the same rule-citation link Show-Cats reports (Get-CatsRuleEnforcers).
A `prose-only` concept has nothing in code to enforce and is exempt.

Private helper for the glossary checks; not exported.
```

## comment:2

Section `.PARAMETER Enforcer` of the comment-based help.

```text
Rule citation ('#' form) -> { Analyzers; Tests }, as Get-CatsRuleEnforcers returns it. Defaults to the
repository's enforcers (source tree only).
```
