# pwsh/Base.Docs/private/Get-GlossaryEnforcementViolations.ps1

Check G5 of the glossary: a concept realized in code has a defining rule that something enforces, an analyzer rule or a tagged test. It is
called by `Test-Glossary` and returns one message per unenforced concept.

## help

### synopsis

Lists the realized glossary concepts whose defining rule nothing enforces (check G5) — one message per violation.

### description

A concept realized in code is only as reliable as the check behind it
([ADR-REPO-VOCAB](../../../../drs/repository/controlled-vocabulary.md),
[ADR-REPO-VOCAB-REALIZEDBY](../../../../drs/repository/controlled-vocabulary.md#rule-adr-repo-vocab-realizedby)). For every concept whose
source takes part in the `enforced` check and whose `realized_by.kind` is not `prose-only`, this reports a defining rule (`defined_by`) with
no enforcer: no analyzer rule mapped to it and no test citing it in a `-Tag` — the same rule-citation link Show-Catzc reports
(Get-RuleEnforcers). A `prose-only` concept has nothing in code to enforce and is exempt.

Private helper for the glossary checks; not exported.

### parameter `Entry`

The merged glossary, as Get-Glossary returns it. Defaults to the repository's glossary.

### parameter `Enforcer`

Rule citation ('#' form) -> { Analyzers; Tests }, as Get-RuleEnforcers returns it. Defaults to the repository's enforcers (source tree
only).

### outputs

`[string[]]` One message per unenforced concept, in glossary order; empty when every realized concept is enforced.

### example 1

```powershell
Get-GlossaryEnforcementViolations
```
