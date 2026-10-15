<#
.SYNOPSIS
    Fast, subprocess-free check: does a resolved tool location belong to the installer layer?
.DESCRIPTION
    Advisory only: a false foreign flag is acceptable, as Get-ToolsStatus stays the precise, process-backed classifier.
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

    # Off Windows the OS owns an MSYS2 tool wherever it sits; on Windows it must be inside its own install tree.
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

    # uv shims land in its bin, but a managed python can also resolve straight into uv's data directory.
    # [comment:3](/docs/references/automation/catzc-tooling-core/private/Test-ToolLocationManaged.ps1.md#comment3)
    if ($Config.uv_tool -or $Config.uv_python) {
        # The data directory is Roaming AppData uv on Windows and share/uv on Unix, apart from the shim bin.
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

    # Winget has two user layouts, and both roots must count, or a winget-managed JDK reads as foreign.
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
