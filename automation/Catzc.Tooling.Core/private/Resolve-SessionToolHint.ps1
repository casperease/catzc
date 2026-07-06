<#
.SYNOPSIS
    Points the current session at a tool installed outside the installer layer, using its declared hints.
.DESCRIPTION
    When a configured tool is not resolvable on PATH but tools.yml gives it session_path_hints (e.g. node's
    nvm-for-windows symlink %ProgramFiles%\nodejs), this prepends the first hint directory that actually
    contains the command to $env:PATH for THIS session only, then returns the resolved command. Session-only,
    never persistent — the installer layer owns the registry PATH. Returns $null when the tool has no hints or
    none resolve.
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

        # Does the command actually live in this dir? Probe the bare name plus the Windows executable
        # extensions (PATHEXT is empty on Unix, so only the bare name is probed there).
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

        # Point THIS session at it: prepend so it wins over anything already on PATH.
        $sep = [System.IO.Path]::PathSeparator
        if (($env:PATH -split $sep) -notcontains $dir) {
            $env:PATH = "$dir$sep$env:PATH"
        }
        # -First 1: with the hint dir prepended, the command may now resolve in MORE than one PATH dir —
        # an array's .Source would break the [string] -Location binding downstream.
        return Get-Command $Config.command -CommandType Application -ErrorAction Ignore | Select-Object -First 1
    }

    return $null
}
