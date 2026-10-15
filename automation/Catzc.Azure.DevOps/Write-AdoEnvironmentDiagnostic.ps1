<#
.SYNOPSIS
    Displays whitelisted environment variables for pipeline diagnostics.
.DESCRIPTION
    Reads the whitelist from configs/pipeline-env.yml and displays only those environment variables.
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
