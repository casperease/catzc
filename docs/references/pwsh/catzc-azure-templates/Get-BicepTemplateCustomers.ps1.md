# automation/Catzc.Azure.Templates/Get-BicepTemplateCustomers.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Returns a template's configured customer names as a flat string array.

### description

The single source of the customer list used by the -Customer ArgumentCompleter (the deploy paths are session-determined and take no
customer). A template's customers ARE its configuration subfolders: each `configuration/<customer>/` folder contributes its customer key.
This returns the distinct customer names from discovery, so `-Customer <TAB>` offers exactly the customers the bound -Template actually
ships configs for.

Returns an empty array when -Template is omitted/unknown or the template is core-only — completers must degrade quietly, never throw.

Centralising it (like Get-BicepTemplateNames / Get-BicepTemplateSlots) keeps the completer scriptblocks one-liners and avoids the
`[ordered]-dict` / comma-wrapped Get-BicepTemplates traps.

### parameter `Template`

Template name (folder under infrastructure/templates/).

### example 1

```powershell
Get-BicepTemplateCustomers sample-customer   # -> acme
```
