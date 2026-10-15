<#
---
catzc:
  derived:
    path: automation/Catzc.Tooling.Core/private/Resolve-SessionToolHint.ps1
    kind: private-function
    module: Catzc.Tooling.Core
    visibility: private
    adrs: []
---
#>

<#
.SYNOPSIS
    Points the current session at a tool installed outside the installer layer, using its declared hints.
.DESCRIPTION
    Session-only, never persistent, since the installer layer owns the registry PATH; null when no hint resolves.
.PARAMETER Config
    The tool's ToolConfig (from Get-ToolConfig).
#>
function Resolve-SessionToolHint {
    [OutputType([System.Management.Automation.CommandInfo])]
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        $Config
    )

    foreach ($hint in $Config.session_path_hints) {
        $dir = [System.Environment]::ExpandEnvironmentVariables($hint)
        if ([string]::IsNullOrWhiteSpace($dir) -or -not (Test-Path -LiteralPath $dir)) {
            continue
        }

        # PATHEXT is empty on Unix, so only the bare name is probed there, plus the executable extensions on Windows.
        # [comment:2](/docs/references/automation/catzc-tooling-core/private/Resolve-SessionToolHint.ps1.md#comment2)
        $names = @($Config.command) +
        (@($env:PATHEXT -split ';') | Where-Object { $_ } | ForEach-Object { "$($Config.command)$_" })
        $present = $false
        foreach ($n in $names) {
            if (Test-Path -LiteralPath (Join-Path $dir $n)) {
                $present = $true
                break
            }
        }
        if (-not $present) {
            continue
        }

        # Append, never prepend: a hint dir that holds its own python.exe, like the az venv, must not shadow python.
        # [comment:3](/docs/references/automation/catzc-tooling-core/private/Resolve-SessionToolHint.ps1.md#comment3)
        $sep = [System.IO.Path]::PathSeparator
        if (($env:PATH -split $sep) -notcontains $dir) {
            $env:PATH = "$env:PATH$sep$dir"
            Write-Message "Session PATH: appended '$dir' so $($Config.command) resolves (session_path_hints)"
        }
        # One result only: an array would break the string Location binding downstream.
        # [comment:4](/docs/references/automation/catzc-tooling-core/private/Resolve-SessionToolHint.ps1.md#comment4)
        return Get-Command $Config.command -CommandType Application -ErrorAction Ignore | Select-Object -First 1
    }

    return $null
}
