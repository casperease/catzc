<#
---
catzc:
  immutable:
    path: automation/Catzc.Azure.Templates/Get-AzureBicepDeploymentModes.ps1
    name: get-azure-bicep-deployment-modes
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    module: Catzc.Azure.Templates
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    test: automation/Catzc.Azure.Templates/tests/Get-AzureBicepDeploymentModes.Tests.ps1
  config:
    synopsis: Returns the supported bicep deployment modes.
    description: |-
      'Incremental' (default) — additive update; existing resources outside the template are preserved.
      'Complete'              — destructive sync; resources in the target scope but not in the template are deleted.
      'DoNotRun'              — pseudo-mode meaning the template is intentionally skipped (gate-checked by callers).
    examples:
      - Get-AzureBicepDeploymentModes
---
#>

function Get-AzureBicepDeploymentModes {
    param()
    @('Incremental', 'Complete', 'DoNotRun')
}
