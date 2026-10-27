function Sync-AdoServiceConnections {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessForStateChangingFunctions', '',
        Justification = 'Uses -DryRun instead of ShouldProcess — see ADR-PWSH-DRYRUN-SUPPRESSSHOULDPROCESS')]
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [string] $Project = (Get-Config -Config ado)['project'],

        [string] $Organization = (Get-Config -Config ado)['organization'],

        [switch] $DryRun
    )

    Assert-NotNullOrWhitespace $Project -ErrorText 'Project is required. Set -Project or configure ado.yml.'
    Assert-NotNullOrWhitespace $Organization -ErrorText 'Organization is required. Set -Organization or configure ado.yml.'
    $Organization = $Organization.TrimEnd('/')

    # The project's id: a connection is shared into the project by it.
    $projectRecord = Invoke-AdoRestMethod -Uri "$Organization/_apis/projects/$([uri]::EscapeDataString($Project))?api-version=7.1" -UnwrapValue $false
    Assert-NotNull $projectRecord -ErrorText "Project '$Project' does not exist in $Organization."
    $context = [pscustomobject]@{
        Organization = $Organization
        Project      = $Project
        ProjectId    = "$($projectRecord.id)"
        ApiBase      = "$Organization/$Project/_apis"
    }

    foreach ($connection in (Get-Config -Config service-connections).connections.Values) {
        $subscription = Get-AzureSubscription -Subscription $connection.subscription
        $synced = Sync-AdoServiceConnection -Context $context -Connection $connection -Subscription $subscription -DryRun:$DryRun
        [pscustomobject]@{
            Kind    = 'ServiceConnection'
            Target  = $connection.name
            Action  = $synced
            Details = "subscription $($connection.subscription) ($($subscription.id)), $([Catzc.Azure.DevOps.ServiceConnectionsConfig]::Scheme)"
            DryRun  = [bool]$DryRun
        }
    }
}
