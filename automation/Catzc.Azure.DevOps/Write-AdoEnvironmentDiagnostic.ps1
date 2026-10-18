<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Azure.DevOps/Write-AdoEnvironmentDiagnostic.ps1
    name: write-ado-environment-diagnostic
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Azure.DevOps
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
---
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
