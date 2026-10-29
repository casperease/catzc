# pwsh/Azure.Templates/private/Get-BicepPreparedConfiguration.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading. Prose written above the first section survives every
later export.

## help

### synopsis

Builds the configuration of one Bicep slot, ready to become its parameters file.

### description

Reads the slot's configuration (Get-BicepTemplateConfiguration), refuses any key still `UNDEFINED`, and resolves its address parameters
(Resolve-BicepParameterAddresses) and its fact parameters (Resolve-BicepEnvironmentFacts). The shared addresses, derived names and
environment facts that options.yml declares are added as parameter entries; a slot that writes one of them is refused. The template's
prepare hook then runs with the build invocation (template, environment, slot, subscription, customer), and its result must hold
`ParametersFile`. Private helper of the Bicep build; not exported.

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

Above `$slotParameters = $configurationDescriptor.ParametersFile.parameters`, written with `#`.

```text
The names options.yml declares come from the namer, before the hook, so a hook sees them; a slot that writes one is refused.
An each entry's items are the slot's own (their subscriptions); the resolver fills their names and refuses an item that writes one.
```
