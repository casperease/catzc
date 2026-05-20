<#
.SYNOPSIS
    Uninstalls a pip-managed tool.
.DESCRIPTION
    Private helper for Uninstall-Poetry and Uninstall-AzCli. Mirrors
    Uninstall-Tool's contract but uses pip instead of platform package
    managers. Idempotent — skips if the tool or Python is not installed.
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
    Assert-NotNullOrWhitespace $config.pip_package -ErrorText "$Tool has no pip_package in tools.yml — cannot uninstall via pip"

    # Idempotent: skip if tool is not installed
    if (-not (Test-Command $config.command)) {
        Write-Message "$Tool is not installed — nothing to do"
        return
    }

    # Python required for pip uninstall. Test-Tool -SkipVersionCheck checks
    # presence and functionality — filters out Windows Store stubs.
    if (-not (Test-Tool 'python' -SkipVersionCheck)) {
        Write-Message 'Python is not available — pip packages already gone'
        return
    }

    # Call pip directly — Invoke-Pip asserts tool version which is unnecessary
    # and can fail during uninstall (e.g., wrong version during teardown).
    Invoke-Executable "python -m pip uninstall $($config.pip_package) -y"
    Write-Message "$Tool uninstalled"
}
