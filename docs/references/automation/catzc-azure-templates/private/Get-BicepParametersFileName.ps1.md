# automation/Catzc.Azure.Templates/private/Get-BicepParametersFileName.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its
comment sat above (Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

The build-artifact parameters filename for a (customer?, env, slot) config.

### description

The single source of the per-slot parameters artifact name, used by both Build-Bicep (which writes
it) and Get-BicepDeploymentContext (which reads it) so the two can never drift — the same principle
as the derived RG name (Get-BicepResourceGroupName).

`parameters.<config>.json` for a configuration-root (shared-platform) slot, or
`parameters.<customer>.<config>.json` for a customer slot — where `<config>` is `<env>[-<slot>]`
(Get-BicepConfigName). The artifact names mirror the configuration tree exactly: all of a template's
slots render into one build folder, and keying on the customer keeps them structurally
collision-free ((customer?, env, slot) is unique) with no guard to remember. See
[ADR-AZ-DATAMOD](../../../../adr/azure/azure-data-model.md).

### parameter Environment

Environment name.

### parameter Slot

Optional special-slot discriminator; omitted ⇒ the base slot.

### parameter Customer

The customer (configuration subfolder) the slot belongs to; omitted/'' ⇒ a configuration-root slot.

### example 1

```powershell
Get-BicepParametersFileName -Environment dev                     # -> parameters.dev.json
```

### example 2

```powershell
Get-BicepParametersFileName -Environment dev -Slot 001 -Customer apex   # -> parameters.apex.dev-001.json
```
