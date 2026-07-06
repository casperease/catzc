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

        # Point THIS session at it by APPENDING the hint dir. The hint only fires when the command is otherwise
        # unresolvable, so nothing conflicts — and appending avoids a hint dir that also holds a python.exe (an
        # az uv-venv Scripts dir) shadowing the managed `python` on ~/.local/bin.
        $sep = [System.IO.Path]::PathSeparator
        if (($env:PATH -split $sep) -notcontains $dir) {
            $env:PATH = "$env:PATH$sep$dir"
        }
        # -First 1: the command may now resolve in more than one PATH dir — an array's .Source would break the
        # [string] -Location binding downstream.
        return Get-Command $Config.command -CommandType Application -ErrorAction Ignore | Select-Object -First 1
    }

    return $null
}
