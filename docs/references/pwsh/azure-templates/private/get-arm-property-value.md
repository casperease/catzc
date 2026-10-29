# pwsh/Azure.Templates/private/Get-ArmPropertyValue.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading. Prose written above the first section survives every
later export.

## help

### synopsis

Collects the values at a dot-separated path inside an ARM resource.

### description

Walks the path one segment at a time from the resource. A segment ending in `[*]` takes every item of the array under its key, or the input
of a property copy loop of that name when the key is absent. A node that is not a dictionary, or lacks the key, drops out. Private helper of
the ARM resource checks; not exported.

### parameter `Resource`

The ARM resource, as a dictionary.

### parameter `Path`

The dot-separated keys from the resource root, such as `properties.networkAcls.ipRules[*].value`.

### outputs

`[System.Collections.Generic.List[object]]` Every value found; empty when the path leads nowhere.

### example 1

```powershell
Get-ArmPropertyValue -Resource $resource -Path 'properties.subnets[*].name'
```

## comment:1

Above `[Parameter(Mandatory)]` (occurrence 2), written with `#`.

```text
Dot-separated keys from the resource root; a key ending in [*] takes every item of its array, or the input of a property copy loop
of that name, which stands for every instance.
```
