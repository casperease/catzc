# automation/Catzc.Base.Variants/private/Get-Variant.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its
comment sat above (Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Reads a single repo-wide variant from configs/variants.yml, as the typed value VariantsConfig holds.

### description

The one place variants.yml is read. Variants are fixed for the importer session (Get-Config caches the
parsed config per session; re-run the importer to pick up an edit — see
[ADR-AUTO-CACHE](../../../../adr/automation/caching.md)).
The typed primitives (Get-AdoNaming, Test-HaveCustomers, …) are thin wrappers over this reader so the
growing variant dictionary has a single access point. Private — callers use the named primitives. A key the
file omits holds the default VariantsConfig declares once, so this reader names no default of its own
([ADR-AUTO-DEFAULT#6](../../../../adr/automation/sensible-defaults.md#rule-adr-auto-default6)).

### parameter Name

The variant key (a top-level key of variants.yml, e.g. 'ado_naming').

### example 1

```powershell
Get-Variant -Name ado_naming
```
