# pwsh/Catzc.Base.Docs/private/Get-GlossaryRuleStatements.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Maps every indexed ADR rule id to the text of its normative summary that can define a term.

### description

Walks the ADRs the index lists (Get-CatsAdrIndex) and reads each one's rules (Get-CatsAdrRules), keeping each rule's Statement — its whole
normative summary on one line — with inline code spans removed. A code span is a mention, never a definition
([ADR-REPO-VOCAB-AVOIDEDPHRASINGREPLACED](../../../../adr/repository/controlled-vocabulary.md#rule-adr-repo-vocab-avoidedphrasingreplaced)),
so `A **<term>** is …` written in backticks neither anchors nor defines a term. This is the one text the anchoring (G2) and
single-definition (G3) checks match against
([ADR-REPO-VOCAB-DEFINEDTERM](../../../../adr/repository/controlled-vocabulary.md#rule-adr-repo-vocab-definedterm)); ADR bodies are never
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
(Get-GlossaryRuleStatements -IndexPath (Resolve-RepoPath 'docs/adr/index.md'))['ADR-REPO-VOCAB-DEFINEDTERM']
```
