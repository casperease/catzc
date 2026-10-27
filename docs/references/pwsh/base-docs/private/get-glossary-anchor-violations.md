# pwsh/Base.Docs/private/Get-GlossaryAnchorViolations.ps1

Check G2 of the glossary: every defined term is anchored, bolded in the normative summary of the rule its concept names in `defined_by`. It
is called by `Test-Glossary` and returns one message per term that is not.

## help

### synopsis

Lists the glossary terms that are not anchored on their defining rule (check G2) — one message per violation.

### description

A defined term has one home: the ADR rule its concept names in `defined_by`, whose normative summary bolds it
([ADR-REPO-VOCAB-DEFINEDTERM](../../../../drs/repository/controlled-vocabulary.md#rule-adr-repo-vocab-definedterm)). For every concept whose
source takes part in the `anchored` check, this reports:

- a `defined_by` citation that names no rule of any indexed ADR;
- a defining rule whose normative summary does not contain `**<term>**` (case-insensitive, whitespace collapsed, so a term bolded across a
  wrapped line still counts).

Only the normative summary counts (Get-DrsRules' Statement): bold text in the ADR body or in the rule's linked bullets never anchors a
term, and neither does a mention inside an inline code span.

Private helper for the glossary checks; not exported.

### parameter `Entry`

The merged glossary, as Get-Glossary returns it. Defaults to the repository's glossary.

### parameter `IndexPath`

Absolute path to the ADR index whose ADRs hold the rules. Defaults to [index](../../../../drs/index.md); a test points it at a fixture index
beside fixture ADR files.

### outputs

`[string[]]` One message per violation, in glossary order; empty when every term is anchored.

### example 1

```powershell
Get-GlossaryAnchorViolations
```
