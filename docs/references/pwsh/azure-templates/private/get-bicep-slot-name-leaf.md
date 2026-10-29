# pwsh/Azure.Templates/private/Get-BicepSlotNameLeaf.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading. Prose written above the first section survives every
later export.

## help

### synopsis

Walks a parsed configuration and emits each string leaf with its location and whether the naming quality gate reads it as a name.

### description

The walk follows mappings and lists. A leaf is a non-empty string. It is a name when a key on its path ends in `Name` or `Names`, unless a
key on the path ends in a `not_names` suffix, which no later key undoes. Each leaf is emitted as an object with `location` (dotted keys,
indexed lists), `value` and `named`. Private helper of the Bicep commands; not exported.

### parameter `Value`

The node to walk: a mapping, a list, a string or `$null`.

### parameter `Location`

The location of the node, empty at the root.

### parameter `State`

The name state on the path so far: 1 when a key ended in `Name` or `Names`, -1 when a key ended in a `not_names` suffix, else 0.

### parameter `NotNames`

The key suffixes whose subtree holds no names.

### outputs

`[pscustomobject]` One object per string leaf with `location`, `value` and `named`.

### example 1

```powershell
Get-BicepSlotNameLeaf -Value $parameters -Location '' -NotNames 'ResourceId'
```
