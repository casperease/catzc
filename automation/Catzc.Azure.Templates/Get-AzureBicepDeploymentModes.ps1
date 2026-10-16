<#
---
catzc:
  derived:
    path: automation/Catzc.Azure.Templates/Get-AzureBicepDeploymentModes.ps1
    kind: function
    language: powershell
    filekind: ps1
    track: automation
    module: Catzc.Azure.Templates
    visibility: public
    relatives:
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
