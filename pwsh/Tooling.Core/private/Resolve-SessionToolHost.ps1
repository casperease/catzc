<#
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-tooling-core/private/Resolve-SessionToolHost.ps1.md"
  header: "generated"
---
#>

function Resolve-SessionToolHost {
    [OutputType([System.Management.Automation.CommandInfo])]
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        $Config
    )

    if (-not $Config.session_host_probes) {
        return $null
    }

    $comparison = if ($IsWindows) {
        [System.StringComparison]::OrdinalIgnoreCase
    }
    else {
        [System.StringComparison]::Ordinal
    }
    $binaryName = if ($IsWindows) {
        "$($Config.command).exe"
    }
    else {
        $Config.command
    }

    # Candidate homes, in preference order and de-duplicated: the managed home, then each PATH match's folder.
    $candidates = [System.Collections.Generic.List[string]]::new()
    if ($Config.script_install) {
        $candidates.Add((Get-ScriptInstallDir -Config $Config).TrimEnd('\', '/'))
    }
    foreach ($match in @(Get-Command $Config.command -CommandType Application -All -ErrorAction Ignore)) {
        $folder = [System.IO.Path]::GetDirectoryName($match.Source).TrimEnd('\', '/')
        $known = $false
        foreach ($candidate in $candidates) {
            if ([string]::Equals($candidate, $folder, $comparison)) {
                $known = $true
                break
            }
        }
        if (-not $known) {
            $candidates.Add($folder)
        }
    }

    $chosen = $null
    foreach ($probe in $Config.session_host_probes) {
        foreach ($candidate in $candidates) {
            if (-not [System.IO.File]::Exists((Join-Path $candidate $binaryName))) {
                continue
            }
            if (Test-ToolHomeProbe -ToolHome $candidate -Probe $probe -Version $Config.version) {
                $chosen = $candidate
                break
            }
        }
        if ($chosen) {
            break
        }
    }
    if (-not $chosen) {
        return $null
    }

    # Move the chosen home to the FRONT of this session's PATH, dropping any later occurrence.
    $separator = [System.IO.Path]::PathSeparator
    $current = @($env:PATH -split $separator)
    $alreadyFirst = $current.Count -gt 0 -and [string]::Equals($current[0].TrimEnd('\', '/'), $chosen, $comparison)
    if (-not $alreadyFirst) {
        $entries = [System.Collections.Generic.List[string]]::new()
        $entries.Add($chosen)
        foreach ($entry in $current) {
            if (-not $entry) {
                continue
            }
            if ([string]::Equals($entry.TrimEnd('\', '/'), $chosen, $comparison)) {
                continue
            }
            $entries.Add($entry)
        }
        $env:PATH = $entries -join $separator
        Write-Message "Session PATH: $($Config.command) now runs from '$chosen'"
    }

    # -First 1, since the command may still resolve in several PATH dirs and an array's .Source would break the [string] -Location binding downstream.
    Get-Command $Config.command -CommandType Application -ErrorAction Ignore | Select-Object -First 1
}
