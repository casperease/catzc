<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-azure-cli/Connect-AzCli.ps1.md"
  header: "generated"
---
#>

function Connect-AzCli {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '',
        Justification = 'The -ServicePrincipal/-ManagedIdentity/-DeviceCode switches are parameter-set discriminators consumed by PowerShell parameter binding (the body branches on $PSCmdlet.ParameterSetName), not referenced directly')]
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

    # Idempotent: a session already on the right identity is kept, and a failed show only means not logged in yet.
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

    # No check after the login: a failed az login throws on its exit code, so the success message is never reached.
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
