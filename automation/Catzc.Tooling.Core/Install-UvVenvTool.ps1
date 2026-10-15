<#
.SYNOPSIS
    Installs a CLI into a dedicated uv venv.
.DESCRIPTION
    For a CLI whose own launcher expects python.exe adjacent to it (azure-cli's az.bat), which an isolated `uv tool`...
    [comment:1](/docs/references/automation/catzc-tooling-core/Install-UvVenvTool.ps1.md#comment1)
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

    # --clear rebuilds the venv clean; --seed adds pip/setuptools/wheel so packages that expect `pkg_resources`...
    # [comment:2](/docs/references/automation/catzc-tooling-core/Install-UvVenvTool.ps1.md#comment2)
    Invoke-Uv "venv `"$venvDir`" --python $pythonVersion --clear --seed"
    Invoke-Uv "pip install --python `"$venvDir`" $($config.uv_venv)==$Version.*" -Prerelease:$config.uv_allow_prerelease

    Sync-SessionPath

    # APPEND the venv's script directory to PATH (the janitor keeps it there each load via session_path_hints).
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
