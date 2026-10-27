# pwsh/Azure.Templates/private/Get-ArmPropertyValue.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading. Prose written above the first section survives every
later export.

## comment:1

Above `[Parameter(Mandatory)]` (occurrence 2), written with `#`.

```text
Dot-separated keys from the resource root; a key ending in [*] takes every item of its array, or the input of a property copy loop
of that name, which stands for every instance.
```
