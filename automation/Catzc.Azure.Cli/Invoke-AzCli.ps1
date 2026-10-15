<#
.SYNOPSIS
    Runs az with the given arguments.
.DESCRIPTION
    Asserts that the installed Azure CLI version matches the locked version in Get-ToolConfig before executing the...
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

    # Disable az dynamic extension install for this call: a command needing an uninstalled extension then exits...
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
