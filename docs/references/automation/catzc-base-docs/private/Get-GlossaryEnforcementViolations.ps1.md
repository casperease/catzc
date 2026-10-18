# automation/Catzc.Base.Docs/private/Get-GlossaryEnforcementViolations.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Lists the realized glossary concepts whose defining rule nothing enforces (check G5) — one message per violation.

### description

A concept realized in code is only as reliable as the check behind it
([ADR-REPO-VOCAB](../../../../adr/repository/controlled-vocabulary.md),
[ADR-REPO-VOCAB#6](../../../../adr/repository/controlled-vocabulary.md#rule-adr-repo-vocab6)). For every concept whose source takes part in
the `enforced` check and whose `realized_by.kind` is not `prose-only`, this reports a defining rule (`defined_by`) with no enforcer: no
analyzer rule mapped to it and no test citing it in a `-Tag` — the same rule-citation link Show-Cats reports (Get-CatsRuleEnforcers). A
`prose-only` concept has nothing in code to enforce and is exempt.

Private helper for the glossary checks; not exported.

### parameter `Entry`

The merged glossary, as Get-Glossary returns it. Defaults to the repository's glossary.

### parameter `Enforcer`

Rule citation ('#' form) -> { Analyzers; Tests }, as Get-CatsRuleEnforcers returns it. Defaults to the repository's enforcers (source tree
only).

### outputs

`[string[]]` One message per unenforced concept, in glossary order; empty when every realized concept is enforced.

### example 1

```powershell
Get-GlossaryEnforcementViolations
```
