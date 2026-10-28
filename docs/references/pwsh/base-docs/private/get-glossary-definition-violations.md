# pwsh/Base.Docs/private/Get-GlossaryDefinitionViolations.ps1

Check G3 of the glossary: a term is defined by exactly one rule. It is called by `Test-Glossary` and returns one message for each other rule
whose normative summary defines the term again.

## help

### synopsis

Lists the glossary terms that a second rule defines (check G3) — one message per violation.

### description

A defined term is fixed by exactly one rule
([ADR-REPO-VOCAB-DEFINEDTERM](../../../../drs/repository/controlled-vocabulary.md#rule-adr-repo-vocab-definedterm)). For every concept whose
source takes part in the `single` check, this reports each rule other than its `defined_by` whose normative summary defines the term again:
`**<term>** is` (case-insensitive, whitespace collapsed). The pattern is deliberately conservative — a rule that merely bolds the term is
not a definition — and only normative summaries count (Get-GlossaryRuleStatements): bold text in a record body or inside an inline code span
never does.

Private helper for the glossary checks; not exported.

### parameter `Entry`

The merged glossary, as Get-Glossary returns it. Defaults to the repository's glossary.

### parameter `IndexPath`

Absolute path to the DRS index whose records hold the rules. Defaults to [index](../../../../drs/index.md); a test points it at a fixture
index beside fixture record files.

### outputs

`[string[]]` One message per second definition, in glossary then rule-id order; empty when every term has one.

### example 1

```powershell
Get-GlossaryDefinitionViolations
```
