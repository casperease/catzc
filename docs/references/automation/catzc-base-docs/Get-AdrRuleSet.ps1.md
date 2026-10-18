# automation/Catzc.Base.Docs/Get-AdrRuleSet.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

The flat set of ADR rule-sets declared in adrs.yml — one typed record per ADR.

### description

Returns the RuleSets of the typed ADR registry (Get-Config -Config adrs, an AdrsConfig — mapped and validated by the C# type, so this reads
strong properties, not a slippery ordered dictionary). Each record (Catzc.Base.Docs.AdrRuleSet) carries the internal kebab Slug, the full
External citation code, the domain Code in effect (a leaf override or the domain default), the folder-owning Domain and its Role, and the
optional Terminology token.

### parameter Domain

Restrict to one folder-owning domain (e.g. 'automation'), by name.

### outputs

`[Catzc.Base.Docs.AdrRuleSet[]]` in declaration order.
