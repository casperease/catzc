# pwsh/Base.Variants/Get-AdoNaming.ps1

The reader of the `ado_naming` variant: it returns the Azure resource-name component order the repo declares, with the default the
VariantsConfig type declares when the key is absent.

## help

### synopsis

Returns the active Azure resource-name component order for this repo ('standard' or 'classic').

### description

The `ado_naming` repo-wide variant (configs/variants.yml), fixed for the importer session. It is the order key Get-BicepResourceName passes
to Get-AzureResourceName (a key of Get-AzureNameOrderSet). An unset variant takes the default VariantsConfig declares (DefaultAdoNaming).

`***` Changing this value re-spells EVERY resource name. Resource names are derived from their components, never typed, so flipping the
order renames every deployed resource at its next deploy. Deliberately not a flip-the-switch option. `***`

### example 1

```powershell
Get-AdoNaming   # -> 'standard'
```
