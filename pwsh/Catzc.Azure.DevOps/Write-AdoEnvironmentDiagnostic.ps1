<#
---
catzc:
  immutable:
    with_body_sha: f386fb7fe83e
  edges:
    docs: "[Write-AdoEnvironmentDiagnostic.ps1.md](../../docs/references/pwsh/catzc-azure-dev-ops/Write-AdoEnvironmentDiagnostic.ps1.md)"
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
