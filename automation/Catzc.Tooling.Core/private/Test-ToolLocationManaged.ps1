<#
.SYNOPSIS
    Fast, subprocess-free check: does a resolved tool location belong to the installer layer?
.DESCRIPTION
    The session janitor (Sync-SessionTools) uses this to flag tools running from outside the directories the
    toolchain installs into. It is a cheap PREFIX check by design — no `winget list`, no version probe — so it
    is safe to run for every tool on every import. It is advisory, not authoritative: Get-ToolsStatus (which
    shells out to the package manager) stays the precise classifier. Machine-scope winget / Program Files
    installs, and npm/pip tools whose global bin sits outside the platform root, read as unmanaged here — an
    acceptable false "foreign" for an advisory message, never a gate.
.PARAMETER Config
    The tool's ToolConfig (from Get-ToolConfig).
.PARAMETER Location
    The resolved on-disk path of the tool's command — (Get-Command <command>).Source.
#>
function Test-ToolLocationManaged {
    [OutputType([bool])]
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        $Config,

        [Parameter(Mandatory)]
        [string] $Location
    )

    $loc = $Location.TrimEnd('\', '/')

    # Script-installed tools (e.g. dotnet) live under their own computed home, not a package-manager root.
    if ($Config.script_install) {
        $dir = (Get-ScriptInstallDir -Config $Config).TrimEnd('\', '/')
        return $loc.StartsWith($dir, [System.StringComparison]::OrdinalIgnoreCase)
    }

    # uv-managed tools (az_cli, poetry) and uv-provisioned python install their shims to uv's bin
    # (~/.local/bin cross-platform); managed pythons may also resolve to uv's data dir directly.
    if ($Config.uv_tool -or $Config.uv_python) {
        # uv's shims go to ~/.local/bin; its managed pythons/tool-envs live in the data dir — %APPDATA%\uv
        # (Roaming) on Windows, ~/.local/share/uv on Unix (verified via `uv tool dir` / `uv python dir`).
        $uvRoots = if ($IsWindows) {
            @((Join-Path $env:USERPROFILE '.local\bin'), (Join-Path $env:APPDATA 'uv'))
        }
        else {
            @((Join-Path $HOME '.local/bin'), (Join-Path $HOME '.local/share/uv'))
        }
        foreach ($root in $uvRoots) {
            if ($loc.StartsWith($root.TrimEnd('\', '/'), [System.StringComparison]::OrdinalIgnoreCase)) {
                return $true
            }
        }
        return $false
    }

    # Otherwise: owned iff the binary sits under the platform package manager's install root. npm/pip tools
    # ride the platform runtime, so they read as owned only when that runtime (and thus their global bin) is.
    $roots = if ($IsWindows) {
        @((Join-Path $env:LOCALAPPDATA 'Microsoft\WinGet\Packages'))
    }
    elseif ($IsMacOS) {
        @('/opt/homebrew', '/usr/local')
    }
    else {
        @('/usr')
    }

    foreach ($root in $roots) {
        if ($loc.StartsWith($root.TrimEnd('\', '/'), [System.StringComparison]::OrdinalIgnoreCase)) {
            return $true
        }
    }
    return $false
}
