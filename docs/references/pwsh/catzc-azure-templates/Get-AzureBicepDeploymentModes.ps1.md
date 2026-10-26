# pwsh/Azure.Templates/Get-AzureBicepDeploymentModes.ps1

The function that returns the bicep deployment modes the deploy supports.

## help

### synopsis

Returns the supported bicep deployment modes.

### description

'Incremental' (default) — additive update; existing resources outside the template are preserved. 'Complete' — destructive sync; resources
in the target scope but not in the template are deleted. 'DoNotRun' — pseudo-mode meaning the template is intentionally skipped
(gate-checked by callers).

### example 1

```powershell
Get-AzureBicepDeploymentModes
```
