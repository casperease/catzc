# automation/Catzc.Azure.Templates/Get-BicepTemplate.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Returns the descriptor for a single bicep template by name.

### parameter `Name`

Template name (the folder name under infrastructure/templates/).

### example 1

```powershell
$t = Get-BicepTemplate sample
$t.main
$t.environments
```

## comment:1

Above `$template = (Get-BicepTemplates) | Where-Object { $_.name -eq $Name } |...`, written with `#`.

```text
Parenthesise the call so its (comma-wrapped, array-preserving) output is collected and then
enumerated element-by-element into Where-Object. A bare `Get-BicepTemplates | Where-Object`
feeds the whole array as a single pipeline object, which silently matches via member
enumeration and returns every template (latent until a second template exists).
```
