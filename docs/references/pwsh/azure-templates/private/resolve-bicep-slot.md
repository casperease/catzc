# pwsh/Azure.Templates/private/Resolve-BicepSlot.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading. Prose written above the first section survives every
later export.

## help

### synopsis

Finds the slot a template declares for a coordinate, or derives an ephemeral slot on its base slot.

### description

A slot the template declares with the environment, slot and customer wins. Otherwise, when a slot name is given and the base slot of that
environment and customer exists, a runtime slot is built on it, named `<environment>-<slot>`, with the base slot's subscription and file.
Anything else answers `$null`. Private helper of the Bicep commands; not exported.

### parameter `TemplateDescriptor`

The template, as Get-BicepTemplate returns it.

### parameter `Environment`

The environment of the coordinate.

### parameter `Slot`

The slot name. Empty selects the base slot.

### parameter `Customer`

The customer of the coordinate. Empty for the shared platform.

### outputs

`[Catzc.Azure.Templates.BicepSlot]` The slot, or `$null` when none matches.

### example 1

```powershell
Resolve-BicepSlot -TemplateDescriptor $template -Environment dev -Slot pr42
```

## comment:1

Above `$base = @($TemplateDescriptor.slots | Where-Object { $_.environment -eq...`, written with `#`.

```text
An ephemeral slot has no file: the base slot of its coordinate deploys again under a runtime slot segment, so every name it
derives carries the segment and nothing else differs.
```
