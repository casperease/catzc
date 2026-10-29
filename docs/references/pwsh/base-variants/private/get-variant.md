# pwsh/Base.Variants/private/Get-Variant.ps1

The module's one reader of a single repo-wide variant: every public getter and guard goes through it, so each variant is read the same way,
as the typed value VariantsConfig holds.

## help

### synopsis

Reads a single repo-wide variant from configs/variants.yml, as the typed value VariantsConfig holds.

### description

The one place variants.yml is read. Variants are fixed for the importer session (Get-Config caches the parsed config per session; re-run the
importer to pick up an edit — see [ADR-AUTO-CACHE](../../../../drs/automation/caching.md)). The typed primitives (Get-Naming,
Test-HaveCustomers, …) are thin wrappers over this reader so the growing variant dictionary has a single access point. Private — callers use
the named primitives. A key the file omits holds the default VariantsConfig declares once, so this reader names no default of its own
([ADR-AUTO-DEFAULT-ONERESOLUTIONORDER](../../../../drs/automation/sensible-defaults.md#rule-adr-auto-default-oneresolutionorder)).

### parameter `Name`

The variant key (a top-level key of variants.yml, e.g. 'naming').

### example 1

```powershell
Get-Variant -Name naming
```
