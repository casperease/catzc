<#
---
catzc:
  derived:
    path: automation/Catzc.Tooling.Core/private/Resolve-SessionToolHost.ps1
    kind: automation-function
    module: Catzc.Tooling.Core
    visibility: private
  config:
    synopsis: Points the current session at the best install home of a tool, chosen by its session_host_probes.
    description: |-
      Some tools can be installed more than once on one machine, and the first one on PATH is not always usable —
      on Windows a machine-wide, runtime-only C:\Program Files\dotnet precedes the user PATH and shadows the
      managed SDK. When tools.yml gives the tool `session_host_probes`, this considers every candidate home in
      order — the installer layer's own home first (Get-ScriptInstallDir, for a script-installed tool), then the
      directory of every PATH match — and takes the FIRST probe that ANY home satisfies (Test-ToolHomeProbe): for
      dotnet an SDK at the locked version, else a runtime at the locked version. The chosen home moves to the
      front of $env:PATH for THIS session only, announced on the information stream because it changes what the
      session runs. No other install is removed and the registry PATH is never written. Returns the resolved
      command, or $null when the tool declares no probes or no home satisfies any of them (PATH is then left
      exactly as it was). Filesystem checks only — no process is started.
    parameters:
      Config: The tool's ToolConfig (from Get-ToolConfig).
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

    # -First 1: the command may still resolve in more than one PATH dir — an array's.Source would break the [string]...
    # [comment:3](/docs/references/automation/catzc-tooling-core/private/Resolve-SessionToolHost.ps1.md#comment3)
    Get-Command $Config.command -CommandType Application -ErrorAction Ignore | Select-Object -First 1
}
