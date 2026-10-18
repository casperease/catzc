# pwsh/Catzc.Azure.Templates/Get-BicepTemplateNames.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Returns the names of all discovered bicep templates as a flat string array.

### description

The single source of the template-name list used by the ArgumentCompleter / ValidateScript blocks on every -Template parameter. Centralising
it removes the repeated `Get-BicepTemplates | ForEach-Object { $_.name }` and the member-enumeration trap that the comma-wrapped
Get-BicepTemplates return invites (see Get-BicepTemplate for the same caution).

### example 1

```powershell
Get-BicepTemplateNames   # -> sample, sample-indexed, sample-subscription, sample-with-prepost
```
