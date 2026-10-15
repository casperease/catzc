# docs/references/automation/catzc-azure-templates/Get-BicepTemplateNames.ps1.md

`automation/Catzc.Azure.Templates/Get-BicepTemplateNames.ps1`

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
The single source of the template-name list used by the ArgumentCompleter / ValidateScript
blocks on every -Template parameter. Centralising it removes the repeated
`Get-BicepTemplates | ForEach-Object { $_.name }` and the member-enumeration trap that the
comma-wrapped Get-BicepTemplates return invites (see Get-BicepTemplate for the same caution).
```
