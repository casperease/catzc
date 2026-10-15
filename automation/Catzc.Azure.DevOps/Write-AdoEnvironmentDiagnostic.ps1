<#
---
catzc:
  derived:
    path: automation/Catzc.Azure.DevOps/Write-AdoEnvironmentDiagnostic.ps1
    kind: function
    module: Catzc.Azure.DevOps
    visibility: public
    adrs: []
---
#>

<#
.SYNOPSIS
    Displays whitelisted environment variables for pipeline diagnostics.
.DESCRIPTION
    A whitelisted variable that is not set is shown empty, so operators see the gap, not a silent omission.
    [comment:1](/docs/references/automation/catzc-azure-devops/Write-AdoEnvironmentDiagnostic.ps1.md#comment1)
.EXAMPLE
    Write-AdoEnvironmentDiagnostic
#>
function Write-AdoEnvironmentDiagnostic {
    [CmdletBinding()]
    param()

    $whitelist = (Get-Config -Config pipeline-env).variables

    $entries = foreach ($name in $whitelist) {
        $value = [System.Environment]::GetEnvironmentVariable($name)
        if ($null -ne $value) {
            @{ Name = $name; Value = $value }
        }
    }

    $sorted = $entries | Sort-Object { $_.Name }
    foreach ($entry in $sorted) {
        Write-Message "$($entry.Name.PadRight(40)) $($entry.Value)" -NoHeader
    }
}
