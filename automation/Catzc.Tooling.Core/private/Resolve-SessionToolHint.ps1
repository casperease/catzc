<#
.SYNOPSIS
    Points the current session at a tool installed outside the installer layer, using its declared hints.
.DESCRIPTION
    When a configured tool is not resolvable on PATH but tools.yml gives it session_path_hints (e.g.
    [comment:1](/docs/references/automation/catzc-tooling-core/private/Resolve-SessionToolHint.ps1.md#comment1)
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

        # Does the command actually live in this dir? Probe the bare name plus the Windows executable extensions...
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

        # Point THIS session at it by APPENDING the hint dir.
        # [comment:3](/docs/references/automation/catzc-tooling-core/private/Resolve-SessionToolHint.ps1.md#comment3)
        $sep = [System.IO.Path]::PathSeparator
        if (($env:PATH -split $sep) -notcontains $dir) {
            $env:PATH = "$env:PATH$sep$dir"
            Write-Message "Session PATH: appended '$dir' so $($Config.command) resolves (session_path_hints)"
        }
        # -First 1: the command may now resolve in more than one PATH dir — an array's.Source would break the...
        # [comment:4](/docs/references/automation/catzc-tooling-core/private/Resolve-SessionToolHint.ps1.md#comment4)
        return Get-Command $Config.command -CommandType Application -ErrorAction Ignore | Select-Object -First 1
    }

    return $null
}
