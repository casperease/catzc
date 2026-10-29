# pwsh/Base.Variants/Get-Naming.ps1

The reader of the `naming` variant: it returns the Azure resource-name segment order the repo declares, with the default the VariantsConfig
type declares when the key is absent.

## help

### synopsis

Returns the active Azure resource-name naming: a preset ('standard' or 'classic') or the explicit segment list.

### description

The `naming` repo-wide variant (configs/variants.yml), fixed for the importer session. It is either a preset name or an explicit list naming
all eight segments (env, slot, region, org, short_name, customer, role, type) exactly once. An unset variant takes the default
VariantsConfig declares (DefaultNaming).

`***` Changing this value re-spells EVERY resource name. Resource names are derived from their components, never typed, so flipping the
order renames every deployed resource at its next deploy. Deliberately not a flip-the-switch option. `***`

### example 1

```powershell
Get-Naming   # -> 'standard'
```
