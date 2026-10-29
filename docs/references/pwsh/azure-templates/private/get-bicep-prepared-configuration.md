# pwsh/Azure.Templates/private/Get-BicepPreparedConfiguration.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading. Prose written above the first section survives every
later export.

## help

### synopsis

Builds the configuration of one Bicep slot, ready to become its parameters file.

### description

Reads the slot's configuration (Get-BicepTemplateConfiguration), refuses any key still `UNDEFINED`, and resolves its address parameters
(Resolve-BicepParameterAddresses) and its fact parameters (Resolve-BicepEnvironmentFacts), both the slot's own `{ address: }` and
`{ fact: }` entries. A runtime slot, one the template declares no file for, takes its base slot's names with the base slot's own ones
rendered again with its slot (Resolve-BicepRuntimeSlotNames); a declared slot's names are its own values, used as written. The template's prepare hook then runs with the build invocation (template, environment,
slot, subscription, customer), and its result must hold `ParametersFile`. Private helper of the Bicep build; not exported.

### parameter `TemplateDescriptor`

The template, as Get-BicepTemplate returns it.

### parameter `Slot`

The slot to prepare.

### parameter `PrepareHook`

The template's Invoke-BicepPrepareParameterSet hook, from Get-BicepPrepareHook. Absent, the configuration is used unchanged.

### outputs

`[System.Collections.IDictionary]` The prepared configuration.

### example 1

```powershell
Get-BicepPreparedConfiguration -TemplateDescriptor $template -Slot $slot -PrepareHook (Get-BicepPrepareHook $template)
```

## comment:1

Above `$declared = @($TemplateDescriptor.slots | Where-Object { $_.name -eq...`, written with `#`.

```text
A runtime slot is no slot the template declares: it reads its base slot's names and renders the base slot's own ones with its slot.
A declared slot's names are its own values, used as written.
```
