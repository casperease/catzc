# pwsh/Azure.Templates/private/Get-BicepPreparedConfiguration.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading. Prose written above the first section survives every
later export.

## comment:1

Above `$slotParameters = $configurationDescriptor.ParametersFile.parameters`, written with `#`.

```text
The names options.yml declares come from the namer, before the hook, so a hook sees them; a slot that writes one is refused.
An each entry's items are the slot's own (their subscriptions); the resolver fills their names and refuses an item that writes one.
```
