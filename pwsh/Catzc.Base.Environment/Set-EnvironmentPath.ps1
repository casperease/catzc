<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-base-environment/Set-EnvironmentPath.ps1.md"
  header: "generated"
---
#>

function Set-EnvironmentPath {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessForStateChangingFunctions', '',
        Justification = 'Thin wrapper around [Environment]::SetEnvironmentVariable — the registry I/O seam that exists for testability; guarding/dry-run is the caller''s concern (see Add-/Remove-PermanentPath).')]
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        [AllowEmptyString()]
        [string] $Value,

        [ValidateSet('User', 'Machine')]
        [string] $Scope = 'User'
    )

    $current = [System.Environment]::GetEnvironmentVariable('PATH', $Scope)
    if ($current -eq $Value) {
        return
    }
    $before = @($current -split ';' | Where-Object { $_ })
    $after = @($Value -split ';' | Where-Object { $_ })
    $added = @($after | Where-Object { $_ -notin $before })
    $removed = @($before | Where-Object { $_ -notin $after })

    [System.Environment]::SetEnvironmentVariable('PATH', $Value, $Scope)
    $change = @(
        if ($added) {
            "added '$($added -join "', '")'"
        }
        if ($removed) {
            "removed '$($removed -join "', '")'"
        }
    )
    if (-not $change) {
        $change = @('reordered')
    }
    Write-Message "$Scope PATH: $($change -join '; ')"
}
