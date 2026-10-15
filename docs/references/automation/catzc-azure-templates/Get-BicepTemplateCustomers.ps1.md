# docs/references/automation/catzc-azure-templates/Get-BicepTemplateCustomers.ps1.md

`automation/Catzc.Azure.Templates/Get-BicepTemplateCustomers.ps1`

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
The single source of the customer list used by the -Customer ArgumentCompleter (the deploy paths
are session-determined and take no customer). A template's customers ARE its configuration
subfolders: each `configuration/<customer>/` folder contributes its customer key. This returns the
distinct customer names from discovery, so `-Customer <TAB>` offers exactly the customers the bound
-Template actually ships configs for.

Returns an empty array when -Template is omitted/unknown or the template is core-only — completers
must degrade quietly, never throw.

Centralising it (like Get-BicepTemplateNames / Get-BicepTemplateSlots) keeps the completer
scriptblocks one-liners and avoids the [ordered]-dict / comma-wrapped Get-BicepTemplates traps.
```
