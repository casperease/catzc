<#
---
catzc:
  derived:
    path: automation/Catzc.Azure.Cli/Invoke-AzCli.ps1
    kind: automation-function
    module: Catzc.Azure.Cli
    visibility: public
  config:
    synopsis: Runs az with the given arguments.
    description: |-
      Asserts that the installed Azure CLI version matches the locked version
      in Get-ToolConfig before executing the command.

      Dynamic extension install is disabled for the duration of the call
      (AZURE_EXTENSION_USE_DYNAMIC_INSTALL=no), so a command that requires an
      uninstalled extension fails with a non-zero exit code instead of blocking
      on an interactive "(Y/n)" install prompt that captured stdin would hide.
      That failure surfaces through the usual exit-code assertion as a throw.
    parameters:
      Arguments: Arguments to pass to az.
      PassThru: Return a CliResult object with Output, Errors, Full, and ExitCode.
      NoAssert: Skip exit code assertion.
      Silent: Suppress the command log line.
      DryRun: Return the command string without executing. Used for testing.
    examples:
      - Invoke-AzCli 'account show'
      - Invoke-AzCli 'group list' -PassThru
      - Invoke-AzCli 'version' -DryRun
---
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
    # [comment:3](/docs/references/automation/catzc-azure-cli/Invoke-AzCli.ps1.md#comment3)
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
