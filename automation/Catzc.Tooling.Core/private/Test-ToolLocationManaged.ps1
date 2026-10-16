<#
---
catzc:
  immutable:
    path: automation/Catzc.Tooling.Core/private/Test-ToolLocationManaged.ps1
    folder: private
    name: test-tool-location-managed
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    module: Catzc.Tooling.Core
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: private
  edges:
    page: docs/references/automation/catzc-tooling-core/private/Test-ToolLocationManaged.ps1.md
    test: automation/Catzc.Tooling.Core/tests/Test-ToolLocationManaged.Tests.ps1
  config:
    synopsis: 'Fast, subprocess-free check: does a resolved tool location belong to the installer layer?'
    description: |-
      The session janitor (Sync-SessionTools) uses this to flag tools running from outside the directories the
      toolchain installs into. It is a cheap PREFIX check by design — no `winget list`, no version probe — so it
      is safe to run for every tool on every import. It is advisory, not authoritative: Get-ToolsStatus (which
      shells out to the package manager) stays the precise classifier. On Windows the user-scope roots it trusts
      are both winget layouts (%LOCALAPPDATA%\Microsoft\WinGet\Packages for portable packages and
      %LOCALAPPDATA%\Programs for installer packages such as OpenJDK) plus uv's standalone bin
      (%USERPROFILE%\.local\bin). An MSYS2-package tool (msys2_url) is owned on Windows inside the tree it installs into
      (Get-ScriptInstallDir over its windows_install_dir), and wherever the system puts it elsewhere. Machine-scope /
      Program Files installs, and npm/pip tools whose global bin sits outside the platform root, read as unmanaged
      here — an acceptable false "foreign" for an advisory message, never a gate.
    parameters:
      Config: The tool's ToolConfig (from Get-ToolConfig).
      Location: The resolved on-disk path of the tool's command — (Get-Command <command>).Source.
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

    if ($Config.uv_tool -or $Config.uv_python) {
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
