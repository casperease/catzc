<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-azure-cli/Invoke-AzCli.ps1.md"
  warning: "Generated Header"
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
