<#
.SYNOPSIS
    Runs az with the given arguments.
.DESCRIPTION
    A command needing an uninstalled extension fails with an exit code instead of hanging on a hidden install prompt.
    [comment:1](/docs/references/automation/catzc-azure-cli/Invoke-AzCli.ps1.md#comment1)
.PARAMETER Arguments
    Arguments to pass to az.
.PARAMETER PassThru
    Return a CliResult object with Output, Errors, Full, and ExitCode.
.PARAMETER NoAssert
    Skip exit code assertion.
.PARAMETER Silent
    Suppress the command log line.
.PARAMETER DryRun
    Return the command string without executing. Used for testing.
.EXAMPLE
    Invoke-AzCli 'account show'
.EXAMPLE
    Invoke-AzCli 'group list' -PassThru
.EXAMPLE
    Invoke-AzCli 'version' -DryRun
#>
function Invoke-AzCli {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $Arguments,
        [switch] $PassThru,
        [switch] $NoAssert,
        [switch] $Silent,
        [switch] $DryRun
    )

    Assert-NotNullOrWhitespace $Arguments -ErrorText 'Arguments cannot be empty'

    if (-not $DryRun) {
        Assert-Tool 'az_cli'
    }

    # Process-scoped and restored after the call, so the caller's own setting survives, even an unset one.
    # [comment:2](/docs/references/automation/catzc-azure-cli/Invoke-AzCli.ps1.md#comment2)
    $dynamicInstallVar = 'AZURE_EXTENSION_USE_DYNAMIC_INSTALL'
    $priorDynamicInstall = [Environment]::GetEnvironmentVariable($dynamicInstallVar, 'Process')
    if (-not $DryRun) {
        [Environment]::SetEnvironmentVariable($dynamicInstallVar, 'no', 'Process')
    }
    try {
        Invoke-Executable "az $Arguments" -PassThru:$PassThru -NoAssert:$NoAssert -Silent:$Silent -DryRun:$DryRun
    }
    finally {
        if (-not $DryRun) {
            [Environment]::SetEnvironmentVariable($dynamicInstallVar, $priorDynamicInstall, 'Process')
        }
    }
}
