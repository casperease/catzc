<#
.SYNOPSIS
    Fast, subprocess-free check: does a resolved tool location belong to the installer layer?
.DESCRIPTION
    The session janitor (Sync-SessionTools) uses this to flag tools running from outside the directories the
    toolchain installs into. It is a cheap PREFIX check by design — no `winget list`, no version probe — so it
    is safe to run for every tool on every import. It is advisory, not authoritative: Get-ToolsStatus (which
    shells out to the package manager) stays the precise classifier. On Windows the user-scope roots it trusts
    are both winget layouts (%LOCALAPPDATA%\Microsoft\WinGet\Packages for portable packages and
    %LOCALAPPDATA%\Programs for installer packages such as OpenJDK) plus uv's standalone bin
    (%USERPROFILE%\.local\bin). Machine-scope / Program Files installs, and npm/pip tools whose global bin sits
    outside the platform root, read as unmanaged here — an acceptable false "foreign" for an advisory message,
    never a gate.
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

    # OS-provided tools (winget) are owned wherever the OS puts them — never flagged foreign.
    if ($Config.system_provided) {
        return $true
    }

    # Script-installed tools (e.g. dotnet) live under their own computed home, not a package-manager root.
    if ($Config.script_install) {
        $dir = (Get-ScriptInstallDir -Config $Config).TrimEnd('\', '/')
        return $loc.StartsWith($dir, [System.StringComparison]::OrdinalIgnoreCase)
    }

    # uv-venv tools (az_cli) live under the toolchain's dedicated venv root.
    if ($Config.uv_venv) {
        $venvRoot = if ($IsWindows) { Join-Path $env:LOCALAPPDATA 'catzc\venvs' } else { Join-Path $HOME '.local/share/catzc/venvs' }
        return $loc.StartsWith($venvRoot.TrimEnd('\', '/'), [System.StringComparison]::OrdinalIgnoreCase)
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

    # Otherwise: owned iff the binary sits under the platform package manager's user-scope install root. npm/pip
    # tools ride the platform runtime, so they read as owned only when that runtime (and thus their global bin)
    # is. On Windows winget uses two distinct user-scope layouts, and both are ours: PORTABLE packages (node,
    # terraform) link under %LOCALAPPDATA%\Microsoft\WinGet\Packages, while INSTALLER packages (e.g.
    # Microsoft.OpenJDK) land under %LOCALAPPDATA%\Programs — so both roots must count, or a winget-managed JDK
    # reads as foreign. %USERPROFILE%\.local\bin is the standalone/user bin uv installs itself into: Install-Uv
    # treats a uv there (outside the winget root) as a managed, self-updating install, so the janitor agrees
    # rather than flagging it. Machine-scope Program Files installs are deliberately NOT here — they read as
    # foreign, the acceptable coarse-advisory case Get-ToolsStatus resolves authoritatively.
    $roots = if ($IsWindows) {
        @(
            (Join-Path $env:LOCALAPPDATA 'Microsoft\WinGet\Packages'),
            (Join-Path $env:LOCALAPPDATA 'Programs'),
            (Join-Path $env:USERPROFILE '.local\bin')
        )
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
