# pwsh/Base.Docs/private/Get-GlossaryRuleStatements.ps1

The shared text source of checks G2 and G3: it maps every indexed rule id to its normative summary, with inline code spans removed, so a
mention in backticks never counts as a definition.

## help

### synopsis

Maps every indexed ADR rule id to the text of its normative summary that can define a term.

### description

Walks the ADRs the index lists (Get-CatsDrsIndex) and reads each one's rules (Get-CatsDrsRules), keeping each rule's Statement — its whole
normative summary on one line — with inline code spans removed. A code span is a mention, never a definition
([ADR-REPO-VOCAB-AVOIDEDPHRASINGREPLACED](../../../../drs/repository/controlled-vocabulary.md#rule-adr-repo-vocab-avoidedphrasingreplaced)),
so `A **<term>** is …` written in backticks neither anchors nor defines a term. This is the one text the anchoring (G2) and
single-definition (G3) checks match against
([ADR-REPO-VOCAB-DEFINEDTERM](../../../../drs/repository/controlled-vocabulary.md#rule-adr-repo-vocab-definedterm)); ADR bodies are never
read.

Private helper for the glossary checks; not exported.

### parameter `IndexPath`

Absolute path to the ADR index. ADR paths in it resolve against the index's own folder, so a test can point this at a fixture index beside
fixture ADR files.

### outputs

[System.Collections.Generic.Dictionary[string, string]] Rule id in registry form ('ADR-AUTO-TEST-TWOMANDATORYTAGS') -> statement text,
ordinal keys.

### example 1

```powershell
(Get-GlossaryRuleStatements -IndexPath (Resolve-RepoPath 'docs/drs/index.md'))['ADR-REPO-VOCAB-DEFINEDTERM']
```
