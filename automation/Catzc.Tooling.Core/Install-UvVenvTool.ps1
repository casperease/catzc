<#
.SYNOPSIS
    Installs a CLI into a dedicated uv venv.
.DESCRIPTION
    For a CLI whose own launcher expects python.exe adjacent to it (azure-cli's az.bat), which an isolated
    `uv tool` shim in ~/.local/bin breaks by placing the launcher next to uv's --default python instead. This
    creates a dedicated venv (`uv venv`), installs the package into it (`uv pip install --python <venv>`), and
    puts the venv's script directory on PATH — so the launcher sits beside the venv's own python and works.
    Pre-release resolution (for packages that pin a beta dependency) is threaded through Invoke-Uv's
    -Prerelease switch, which warns. Handles idempotency and -Force.
.PARAMETER Tool
    The snake_case tool key (must declare uv_venv).
.PARAMETER Version
    Version override. Defaults to the locked version.
.PARAMETER Force
    Rebuild the venv from scratch even when the tool is already present.
#>
function Install-UvVenvTool {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $Tool,
        [string] $Version,
        [switch] $Force
    )

    $config = Get-ToolConfig -Tool $Tool
    Assert-NotNullOrWhitespace $config.uv_venv -ErrorText "$Tool has no uv_venv in tools.yml — cannot install into a uv venv"

    if (-not $Version) {
        $Version = $config.version
    }
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
    $scriptsDir = if ($IsWindows) { Join-Path $venvDir 'Scripts' } else { Join-Path $venvDir 'bin' }

    # --clear rebuilds the venv so a -Force or version change starts clean.
    Invoke-Uv "venv `"$venvDir`" --python $pythonVersion --clear"
    Invoke-Uv "pip install --python `"$venvDir`" $($config.uv_venv)==$Version.*" -Prerelease:$config.uv_allow_prerelease

    Sync-SessionPath

    # Put the venv's script directory on the session PATH (the janitor keeps it there each load via the tool's
    # session_path_hints), so the launcher — beside the venv's python — resolves.
    if (($env:PATH -split [System.IO.Path]::PathSeparator) -notcontains $scriptsDir) {
        $env:PATH = "$scriptsDir$([System.IO.Path]::PathSeparator)$env:PATH"
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
