# pwsh/Base.Drs/Get-DrsRuleSet.ps1

Returns the rule sets declared in `drs.yml` as typed records, one per ADR, optionally for one domain.

## help

### synopsis

The flat set of ADR rule-sets declared in drs.yml — one typed record per ADR.

### description

Returns the RuleSets of the typed ADR registry (Get-Config -Config drs, an DrsConfig — mapped and validated by the C# type, so this reads
strong properties, not a slippery ordered dictionary). Each record (Catzc.Base.Drs.DrsRuleSet) carries the internal kebab Slug, the full
External citation code, the domain Code in effect (a leaf override or the domain default), the folder-owning Domain and its Role, and the
optional Terminology token.

### parameter `Domain`

Restrict to one folder-owning domain (e.g. 'automation'), by name.

### outputs

`[Catzc.Base.Drs.DrsRuleSet[]]` in declaration order.
