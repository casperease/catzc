<#
.SYNOPSIS
    Returns the supported bicep deployment modes.
.DESCRIPTION
    'Incremental' (default) — additive update; existing resources outside the template are preserved.
    'Complete'              — destructive sync; resources in the target scope but not in the template are deleted.
    'DoNotRun'              — pseudo-mode meaning the template is intentionally skipped (gate-checked by callers).
.EXAMPLE
    Get-AzureBicepDeploymentModes
#>
function Get-AzureBicepDeploymentModes {
    param()
    @('Incremental', 'Complete', 'DoNotRun')
}
