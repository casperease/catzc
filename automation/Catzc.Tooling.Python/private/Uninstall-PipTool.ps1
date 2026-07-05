<#
.SYNOPSIS
    Uninstalls a Python-library tool from the uv-managed Python via `uv pip`.
.DESCRIPTION
    Private helper for Uninstall-PySpark. Mirrors Uninstall-Tool's contract but removes the package from the
    uv-managed Python with `uv pip uninstall --system`. Idempotent — skips if the tool or Python is not
    installed.
.PARAMETER Tool
    The snake_case tool key as defined in tools.yml.
#>
function Uninstall-PipTool {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string] $Tool
    )

    $config = Get-ToolConfig -Tool $Tool
    Assert-NotNullOrWhitespace $config.pip_package -ErrorText "$Tool has no pip_package in tools.yml — cannot uninstall via uv pip"

    # Idempotent: skip if tool is not installed
    if (-not (Test-Command $config.command)) {
        Write-Message "$Tool is not installed — nothing to do"
        return
    }

    # Python required to host the package. Test-Tool -SkipVersionCheck checks presence and functionality.
    if (-not (Test-Tool 'python' -SkipVersionCheck)) {
        Write-Message 'Python is not available — the package is already gone'
        return
    }

    Invoke-Pip "uninstall --system $($config.pip_package)"
    Write-Message "$Tool uninstalled"
}
