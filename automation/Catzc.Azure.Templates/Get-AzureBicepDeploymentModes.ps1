<#
---
catzc:
  derived:
    path: automation/Catzc.Azure.Templates/Get-AzureBicepDeploymentModes.ps1
    kind: automation-function
    module: Catzc.Azure.Templates
    visibility: public
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
