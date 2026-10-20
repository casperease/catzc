<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Azure.DevOps/Write-AdoEnvironmentDiagnostic.ps1
    name: write-ado-environment-diagnostic
    filetype: ps1
    role: function
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Azure.DevOps
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    docs: "[Write-AdoEnvironmentDiagnostic.ps1.md](docs/references/pwsh/catzc-azure-devops/Write-AdoEnvironmentDiagnostic.ps1.md)"
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
