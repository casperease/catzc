# pwsh/Azure.Templates/private/Assert-BicepParamSibling.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading. Prose written above the first section survives every
later export.

## help

### synopsis

Refuses a yml beside a bicepparam slot that holds anything but a top-level ResourceGroup.

### description

A yml that sits beside a bicepparam slot of the same name only declares the resource group of that slot, so its one allowed key is
`ResourceGroup`. An empty file passes. A file whose root is not a mapping, or that holds any other key, throws and names the template and
the file. Private helper of the Bicep commands; not exported.

### parameter `File`

The path of the sibling yml.

### parameter `Template`

The name of the template, for the error text.

### example 1

```powershell
Assert-BicepParamSibling -File $ymlPath -Template widget
```
