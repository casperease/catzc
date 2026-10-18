# pwsh/Catzc.Base.Docs/private/Get-GlossaryDefinitionViolations.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Lists the glossary terms that a second ADR rule defines (check G3) — one message per violation.

### description

A defined term is fixed by exactly one rule ([ADR-REPO-VOCAB#1](../../../../adr/repository/controlled-vocabulary.md#rule-adr-repo-vocab1)).
For every concept whose source takes part in the `single` check, this reports each rule other than its `defined_by` whose normative summary
defines the term again: `**<term>** is` (case-insensitive, whitespace collapsed). The pattern is deliberately conservative — a rule that
merely bolds the term is not a definition — and only normative summaries count (Get-GlossaryRuleStatements): bold text in an ADR body or
inside an inline code span never does.

Private helper for the glossary checks; not exported.

### parameter `Entry`

The merged glossary, as Get-Glossary returns it. Defaults to the repository's glossary.

### parameter `IndexPath`

Absolute path to the ADR index whose ADRs hold the rules. Defaults to [index](../../../../adr/index.md); a test points it at a fixture index
beside fixture ADR files.

### outputs

`[string[]]` One message per second definition, in glossary then rule-id order; empty when every term has one.

### example 1

```powershell
Get-GlossaryDefinitionViolations
```
