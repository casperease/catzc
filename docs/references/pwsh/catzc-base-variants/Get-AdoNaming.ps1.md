# automation/Catzc.Base.Variants/Get-AdoNaming.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

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
