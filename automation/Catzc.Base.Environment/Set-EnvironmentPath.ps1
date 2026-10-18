<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.Environment/Set-EnvironmentPath.ps1
    name: set-environment-path
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.Environment
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    cites:
      - ADR-AUTO-CONSOLE#11
---
#>

function Set-EnvironmentPath {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessForStateChangingFunctions', '', Justification = 'Thin wrapper around [Environment]::SetEnvironmentVariable — the registry I/O seam that exists for testability; guarding/dry-run is the caller''s concern (see Add-/Remove-PermanentPath).')]
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
