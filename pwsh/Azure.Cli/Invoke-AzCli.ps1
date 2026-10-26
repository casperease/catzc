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

    # Without this, a command needing a missing extension waits on an invisible (Y/n) prompt instead of failing.
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
