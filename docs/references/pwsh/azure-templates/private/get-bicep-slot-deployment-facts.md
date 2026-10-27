# pwsh/Azure.Templates/private/Get-BicepSlotDeploymentFacts.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading. Prose written above the first section survives every
later export.

## comment:1

Above `$azure = Get-Config -Config azure`, written with `#`.

```text
Where Deploy-Bicep sends the slot, read from azure.yml and the naming standard, never from the az session: a fact it does not
declare stays '', and Get-ArmDeployedResource leaves what reads it unresolved.
```
