<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Azure.Cli/Connect-AzCli.ps1
    name: connect-az-cli
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Azure.Cli
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    page: docs/references/automation/catzc-azure-cli/Connect-AzCli.ps1.md
  config:
    synopsis: Logs in to Azure CLI.
    description: Skips login if already authenticated. Use -Force to re-authenticate.
    parameters:
      ServicePrincipal: Login as a service principal. Requires Tenant, ClientId, and ClientSecret.
      ManagedIdentity: Login using managed identity.
      DeviceCode: Login using device code flow (for environments without a browser).
      Tenant: Azure AD tenant ID. Required for service principal login.
      ClientId: Service principal app/client ID. Required for service principal login.
      ClientSecret: Service principal secret. Required for service principal login.
      Force: Force re-authentication even if already logged in.
    examples:
      - Connect-AzCli
      - Connect-AzCli -DeviceCode
      - Connect-AzCli -ServicePrincipal -Tenant $t -ClientId $id -ClientSecret $secret
      - Connect-AzCli -ManagedIdentity
---
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
