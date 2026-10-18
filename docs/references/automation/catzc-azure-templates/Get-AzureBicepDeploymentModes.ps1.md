# automation/Catzc.Azure.Templates/Get-AzureBicepDeploymentModes.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

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
