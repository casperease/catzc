# pwsh/Azure.Templates/private/Resolve-AzureNameOrder.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading. Prose written above the first section survives every
later export.

## help

### synopsis

Resolves a name order to its list of part groups.

### description

A string names one of the known name orders and resolves to that order's groups; an unknown name throws and lists the known ones. Any other
value is taken as a list of groups, each cast to a string array. The result is returned as one array, never unrolled. Private helper of the
Azure naming commands; not exported.

### parameter `Order`

A known name order, or a list of part groups.

### outputs

`[object[]]` The groups of the order, each a string array.

### example 1

```powershell
Resolve-AzureNameOrder -Order 'environment-first'
```
