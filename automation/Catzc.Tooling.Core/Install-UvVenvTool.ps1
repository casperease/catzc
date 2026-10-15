<#
---
catzc:
  derived:
    path: automation/Catzc.Tooling.Core/Install-UvVenvTool.ps1
    kind: function
    module: Catzc.Tooling.Core
    visibility: public
    adrs: []
---
#>

<#
.SYNOPSIS
    Installs a CLI into a dedicated uv venv.
.DESCRIPTION
    A uv tool shim would put the launcher beside uv's default python, but az.bat needs its own python.exe next to it.
.PARAMETER Tool
    The snake_case tool key (must declare uv_venv).
.PARAMETER Version
    Version override. Defaults to the tool's locked version in tools.yml (Get-ToolConfig).
.PARAMETER Force
    Rebuild the venv from scratch even when the tool is already present.
#>
function Install-UvVenvTool {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $Tool,
        [string] $Version = (Get-ToolConfig -Tool $Tool).version,
        [switch] $Force
    )

    $config = Get-ToolConfig -Tool $Tool
    Assert-NotNullOrWhitespace $config.uv_venv -ErrorText "$Tool has no uv_venv in tools.yml — cannot install into a uv venv"

    $pythonVersion = (Get-ToolConfig -Tool 'python').version

    # Idempotent: skip if already installed at the correct version.
    if (-not $Force -and (Test-Command $config.command)) {
        $installed = Get-ToolVersion -Config $config
        if ($installed -and $installed.StartsWith($Version)) {
            Write-Message "$Tool $Version is already installed"
            return
        }
    }

    $venvDir = Get-UvVenvDir -Tool $Tool
    $scriptsDir = if ($IsWindows) {
        Join-Path $venvDir 'Scripts'
    }
    else {
        Join-Path $venvDir 'bin'
    }

    # Seeding adds pip and setuptools, so packages that import pkg_resources, such as the azure-devops extension, load.
    # [comment:2](/docs/references/automation/catzc-tooling-core/Install-UvVenvTool.ps1.md#comment2)
    Invoke-Uv "venv `"$venvDir`" --python $pythonVersion --clear --seed"
    Invoke-Uv "pip install --python `"$venvDir`" $($config.uv_venv)==$Version.*" -Prerelease:$config.uv_allow_prerelease

    Sync-SessionPath

    # Append, never prepend: the venv holds its own python.exe, which would shadow the uv-managed python.
    # [comment:3](/docs/references/automation/catzc-tooling-core/Install-UvVenvTool.ps1.md#comment3)
    if (($env:PATH -split [System.IO.Path]::PathSeparator) -notcontains $scriptsDir) {
        $env:PATH = "$env:PATH$([System.IO.Path]::PathSeparator)$scriptsDir"
        Write-Message "Session PATH: appended '$scriptsDir'"
    }

    Assert-Command $config.command -ErrorText "$Tool was installed into '$venvDir' but '$($config.command)' is not on PATH — its session_path_hints must include '$scriptsDir'."

    $actualVersion = Get-ToolVersion -Config $config
    if ($actualVersion -and $actualVersion.StartsWith($Version)) {
        Write-Message "$Tool $actualVersion installed successfully"
    }
    elseif ($actualVersion) {
        Write-Message "$Tool installed but version $actualVersion does not match expected $Version.x"
    }
    else {
        Write-Message "$Tool installed but could not verify version"
    }
}
