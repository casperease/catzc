<#
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-tooling-core/private/Test-ToolLocationManaged.ps1.md"
  header: "generated"
---
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

    # On Windows an MSYS2-package tool lives in the tree it installs into; elsewhere it is the system's, owned wherever the OS puts it.
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

    # uv shims go to uv's bin (~/.local/bin on every platform), while managed pythons may also resolve to uv's data dir directly.
    if ($Config.uv_tool -or $Config.uv_python) {
        # uv's data dir is %APPDATA%\uv (Roaming) on Windows and ~/.local/share/uv on Unix, verified via uv tool dir and uv python dir.
        $uvRoots = @(if ($IsWindows) {
                @((Join-Path $env:USERPROFILE '.local\bin'), (Join-Path $env:APPDATA 'uv'))
            }
            else {
                @((Join-Path $HOME '.local/bin'), (Join-Path $HOME '.local/share/uv'))
            })
        foreach ($root in $uvRoots) {
            if ($loc.StartsWith($root.TrimEnd('\', '/'), [System.StringComparison]::OrdinalIgnoreCase)) {
                return $true
            }
        }
        return $false
    }

    # Winget has two user-scope layouts, portable under Packages and installer packages under Programs, so both roots count or a winget JDK reads as foreign; Program Files stays out on purpose.
    $roots = @(if ($IsWindows) {
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
        })

    foreach ($root in $roots) {
        if ($loc.StartsWith($root.TrimEnd('\', '/'), [System.StringComparison]::OrdinalIgnoreCase)) {
            return $true
        }
    }
    return $false
}
