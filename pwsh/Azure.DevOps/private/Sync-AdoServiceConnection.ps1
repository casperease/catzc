function Sync-AdoServiceConnection {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessForStateChangingFunctions', '',
        Justification = 'Uses -DryRun instead of ShouldProcess — see ADR-PWSH-DRYRUN-SUPPRESSSHOULDPROCESS')]
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory)]
        [pscustomobject] $Context,

        [Parameter(Mandatory)]
        [object] $Connection,

        [Parameter(Mandatory)]
        [object] $Subscription,

        [switch] $DryRun
    )

    $scheme = [Catzc.Azure.DevOps.ServiceConnectionScheme]::Federated
    # Every connection spans its subscription; the identity's least privilege is the role assignments the templates grant it.
    $scopeLevel = 'Subscription'
    $existing = @(Invoke-AdoRestMethod -Uri "$($Context.ApiBase)/serviceendpoint/endpoints?endpointNames=$([uri]::EscapeDataString($Connection.name))&api-version=7.1") |
        Where-Object { $null -ne $_ -and "$($_.name)" -eq $Connection.name } | Select-Object -First 1

    $desired = [ordered]@{
        name                             = $Connection.name
        type                             = 'azurerm'
        url                              = 'https://management.azure.com/'
        description                      = $Connection.description
        authorization                    = [ordered]@{
            scheme     = $scheme
            parameters = [ordered]@{ tenantid = $Subscription.tenant.id }
        }
        data                             = [ordered]@{
            environment      = 'AzureCloud'
            scopeLevel       = $scopeLevel
            subscriptionId   = $Subscription.id
            subscriptionName = $Subscription.name
            creationMode     = 'Automatic'
        }
        isShared                         = $false
        serviceEndpointProjectReferences = @(
            [ordered]@{
                projectReference = [ordered]@{ id = $Context.ProjectId; name = $Context.Project }
                name             = $Connection.name
                description      = $Connection.description
            }
        )
    }

    $action = if (-not $existing) {
        'Create'
    }
    elseif ("$($existing.authorization.scheme)" -ne $scheme -or "$($existing.data.subscriptionId)" -ne $Subscription.id -or
        "$($existing.data.scopeLevel)" -ne $scopeLevel) {
        'Update'
    }
    else {
        'Unchanged'
    }

    if (-not $DryRun -and $action -eq 'Create') {
        Invoke-AdoRestMethod -Uri "$($Context.Organization)/_apis/serviceendpoint/endpoints?api-version=7.1" -Method Post -Body $desired | Out-Null
    }
    elseif (-not $DryRun -and $action -eq 'Update') {
        # An update converts a secret-scheme connection to federation in place, so the pipelines that name it keep working.
        $desired['id'] = "$($existing.id)"
        Invoke-AdoRestMethod -Uri "$($Context.Organization)/_apis/serviceendpoint/endpoints/$($existing.id)?operation=ConvertAuthenticationScheme&api-version=7.1" -Method Put -Body $desired | Out-Null
    }
    if ($action -ne 'Unchanged') {
        Write-Message "$action service connection '$($Connection.name)' ($scheme)$(if ($DryRun) { ' [dry run]' })"
    }
    $action
}
