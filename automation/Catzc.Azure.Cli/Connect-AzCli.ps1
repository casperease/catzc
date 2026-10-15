<#
---
catzc:
  derived:
    path: automation/Catzc.Azure.Cli/Connect-AzCli.ps1
    kind: function
    module: Catzc.Azure.Cli
    visibility: public
---
#>

<#
.SYNOPSIS
    Logs in to Azure CLI.
.DESCRIPTION
    Skips login if already authenticated. Use -Force to re-authenticate.
.PARAMETER ServicePrincipal
    Login as a service principal. Requires Tenant, ClientId, and ClientSecret.
.PARAMETER ManagedIdentity
    Login using managed identity.
.PARAMETER DeviceCode
    Login using device code flow (for environments without a browser).
.PARAMETER Tenant
    Azure AD tenant ID. Required for service principal login.
.PARAMETER ClientId
    Service principal app/client ID. Required for service principal login.
.PARAMETER ClientSecret
    Service principal secret. Required for service principal login.
.PARAMETER Force
    Force re-authentication even if already logged in.
.EXAMPLE
    Connect-AzCli
.EXAMPLE
    Connect-AzCli -DeviceCode
.EXAMPLE
    Connect-AzCli -ServicePrincipal -Tenant $t -ClientId $id -ClientSecret $secret
.EXAMPLE
    Connect-AzCli -ManagedIdentity
#>
function Connect-AzCli {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'The -ServicePrincipal/-ManagedIdentity/-DeviceCode switches are parameter-set discriminators consumed by PowerShell parameter binding (the body branches on $PSCmdlet.ParameterSetName), not referenced directly')]
    [CmdletBinding(DefaultParameterSetName = 'Interactive')]
    param(
        [Parameter(ParameterSetName = 'ServicePrincipal', Mandatory)]
        [switch] $ServicePrincipal,
        [Parameter(ParameterSetName = 'ManagedIdentity', Mandatory)]
        [switch] $ManagedIdentity,
        [Parameter(ParameterSetName = 'DeviceCode', Mandatory)]
        [switch] $DeviceCode,
        [Parameter(ParameterSetName = 'ServicePrincipal', Mandatory)]
        [string] $Tenant,
        [Parameter(ParameterSetName = 'ServicePrincipal', Mandatory)]
        [string] $ClientId,
        [Parameter(ParameterSetName = 'ServicePrincipal', Mandatory)]
        [string] $ClientSecret,
        [switch] $Force
    )

    Assert-Tool 'az_cli'

    # A non-zero exit from az account show means not logged in, an expected state, so it must not throw.
    # [comment:1](/docs/references/automation/catzc-azure-cli/Connect-AzCli.ps1.md#comment1)
    if (-not $Force) {
        $result = Invoke-Executable 'az account show --output json' -PassThru -NoAssert -Silent
        if ($result.ExitCode -eq 0 -and $result.Output) {
            $account = $result.Output | ConvertFrom-Json
            $alreadyCorrect = switch ($PSCmdlet.ParameterSetName) {
                'ServicePrincipal' {
                    $account.tenantId -eq $Tenant -and $account.user.name -eq $ClientId
                }
                default {
                    $true
                }
            }
            if ($alreadyCorrect) {
                Write-Message "Already authenticated as $($account.user.name)"
                return
            }
        }
    }

    # No post-login check: a failed az login throws in Invoke-Executable, so the success message is never reached.
    # [comment:2](/docs/references/automation/catzc-azure-cli/Connect-AzCli.ps1.md#comment2)
    Write-Verbose "Authenticating via $($PSCmdlet.ParameterSetName)"
    switch ($PSCmdlet.ParameterSetName) {
        'ServicePrincipal' {
            Invoke-Executable "az login --service-principal --tenant $Tenant --username $ClientId --password $ClientSecret"
        }
        'ManagedIdentity' {
            Invoke-Executable 'az login --identity'
        }
        'DeviceCode' {
            Invoke-Executable 'az login --use-device-code'
        }
        'Interactive' {
            Invoke-Executable 'az login'
        }
    }

    Write-Message "Authenticated via $($PSCmdlet.ParameterSetName)"
}
