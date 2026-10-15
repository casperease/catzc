<#
.SYNOPSIS
    Fast, subprocess-free check: does a resolved tool location belong to the installer layer?
.DESCRIPTION
    The session janitor (Sync-SessionTools) uses this to flag tools running from outside the directories the...
    [comment:1](/docs/references/automation/catzc-tooling-core/private/Test-ToolLocationManaged.ps1.md#comment1)
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

    # MSYS2-package tools (zsh) live, on Windows, in the tree they install into (windows_install_dir, the Git for...
    # [comment:2](/docs/references/automation/catzc-tooling-core/private/Test-ToolLocationManaged.ps1.md#comment2)
    if ($Config.msys2_url) {
        if (-not $IsWindows) {
            return $true
        }
        # The separator keeps a sibling such as %LOCALAPPDATA%\GitHub from reading as inside %LOCALAPPDATA%\Git.
        $tree = (Get-ScriptInstallDir -Config $Config).TrimEnd('\', '/') + '\'
        return $loc.StartsWith($tree, [System.StringComparison]::OrdinalIgnoreCase)
    }

    # uv-venv tools (az_cli) live under the toolchain's dedicated venv root.
    if ($Config.uv_venv) {
        $venvRoot = if ($IsWindows) {
            Join-Path $env:LOCALAPPDATA 'catzc\venvs'
        }
        else {
            Join-Path $HOME '.local/share/catzc/venvs'
        }
        return $loc.StartsWith($venvRoot.TrimEnd('\', '/'), [System.StringComparison]::OrdinalIgnoreCase)
    }

    # uv-managed tools (az_cli, poetry) and uv-provisioned python install their shims to uv's bin (~/.local/bin...
    # [comment:3](/docs/references/automation/catzc-tooling-core/private/Test-ToolLocationManaged.ps1.md#comment3)
    if ($Config.uv_tool -or $Config.uv_python) {
        # uv's shims go to ~/.local/bin; its managed pythons/tool-envs live in the data dir — %APPDATA%\uv (Roaming)...
        # [comment:4](/docs/references/automation/catzc-tooling-core/private/Test-ToolLocationManaged.ps1.md#comment4)
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

    # Otherwise: owned iff the binary sits under the platform package manager's user-scope install root.
    # [comment:5](/docs/references/automation/catzc-tooling-core/private/Test-ToolLocationManaged.ps1.md#comment5)
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
