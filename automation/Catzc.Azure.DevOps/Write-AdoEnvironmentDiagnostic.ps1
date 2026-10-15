<#
---
catzc:
  derived:
    path: automation/Catzc.Azure.DevOps/Write-AdoEnvironmentDiagnostic.ps1
    kind: public-function
    module: Catzc.Azure.DevOps
    visibility: public
  config:
    synopsis: Displays whitelisted environment variables for pipeline diagnostics.
    description: |-
      Reads the whitelist from configs/pipeline-env.yml and displays
      only those environment variables. Variables that are not set are shown
      as empty. Designed for the top of every Invoke-AdoScript run so
      operators see build context, paths, and agent info at a glance.
    examples:
      - Write-AdoEnvironmentDiagnostic
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
