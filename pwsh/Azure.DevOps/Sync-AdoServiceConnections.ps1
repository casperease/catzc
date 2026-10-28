function Sync-AdoServiceConnections {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessForStateChangingFunctions', '',
        Justification = 'Uses -DryRun instead of ShouldProcess — see ADR-PWSH-DRYRUN-SUPPRESSSHOULDPROCESS')]
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Mandatory, Position = 0, ValueFromPipeline)]
        [object[]] $Connection,

        [string] $Project = (Get-Config -Config ado)['project'],

        [string] $Organization = (Get-Config -Config ado)['organization'],

        [switch] $DryRun
    )

    begin {
        Assert-NotNullOrWhitespace $Project -ErrorText 'Project is required. Set -Project or configure ado.yml.'
        Assert-NotNullOrWhitespace $Organization -ErrorText 'Organization is required. Set -Organization or configure ado.yml.'
        $organizationUrl = $Organization.TrimEnd('/')

        # The project's id: a connection is shared into the project by it.
        $projectRecord = Invoke-AdoRestMethod -Uri "$organizationUrl/_apis/projects/$([uri]::EscapeDataString($Project))?api-version=7.1" -UnwrapValue $false
        Assert-NotNull $projectRecord -ErrorText "Project '$Project' does not exist in $organizationUrl."
        $context = [pscustomobject]@{
            Organization = $organizationUrl
            Project      = $Project
            ProjectId    = "$($projectRecord.id)"
            ApiBase      = "$organizationUrl/$Project/_apis"
        }
    }

    process {
        foreach ($item in $Connection) {
            $subscription = Get-AzureSubscription -Subscription $item.subscription
            $synced = Sync-AdoServiceConnection -Context $context -Connection $item -Subscription $subscription -DryRun:$DryRun
            [pscustomobject]@{
                Kind    = 'ServiceConnection'
                Target  = $item.name
                Action  = $synced
                Details = "subscription $($item.subscription) ($($subscription.id)), $([Catzc.Azure.DevOps.ServiceConnectionScheme]::Federated)"
                DryRun  = [bool]$DryRun
            }
        }
    }
}
