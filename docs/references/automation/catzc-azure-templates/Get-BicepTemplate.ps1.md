# docs/references/automation/catzc-azure-templates/Get-BicepTemplate.ps1.md

`automation/Catzc.Azure.Templates/Get-BicepTemplate.ps1`

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `$template = (Get-BicepTemplates) | Where-Object { $_.name -eq $Name } |...`.

```text
Parenthesise the call so its (comma-wrapped, array-preserving) output is collected and then
enumerated element-by-element into Where-Object. A bare `Get-BicepTemplates | Where-Object`
feeds the whole array as a single pipeline object, which silently matches via member
enumeration and returns every template (latent until a second template exists).
```
