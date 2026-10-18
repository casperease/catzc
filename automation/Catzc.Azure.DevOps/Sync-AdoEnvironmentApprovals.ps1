function Sync-AdoEnvironmentApprovals {
    [CmdletBinding()]
    [OutputType([PSCustomObject[]])]
    param(
        [string] $Project = (Get-Config -Config ado)['project'],

        [string] $Organization = (Get-Config -Config ado)['organization'],

        [switch] $DryRun
    )

    Assert-NotNullOrWhitespace $Project -ErrorText 'Project is required. Set -Project or configure ado.yml.'
    Assert-NotNullOrWhitespace $Organization -ErrorText 'Organization is required. Set -Organization or configure ado.yml.'
    $config = Get-Config -Config environment-approvals
    Assert-True (@($config.approver_members).Count -gt 0) -ErrorText (
        'approver_group.members is empty in environment-approvals.yml: an approval nobody can give would block every prod-tier deploy. ' +
        "List the approvers' principal names there."
    )

    $context = Get-AdoGraphContext -Project $Project -Organization $Organization
    $group = Sync-AdoGraphGroup -Context $context -Name $config.approver_group -Description $config.approver_description -DryRun:$DryRun
    $members = Sync-AdoGraphGroupMembers -Context $context -Group $group -Member $config.approver_members -DryRun:$DryRun
    $groupName = "[$Project]\$($config.approver_group)"

    [pscustomobject]@{
        Kind    = 'Group'
        Target  = $groupName
        Action  = $group.Action
        Details = "added: $(@($members.Added) -join ', '); removed: $(@($members.Removed).Count)"
        DryRun  = [bool]$DryRun
    }

    foreach ($name in $config.environments) {
        $check = @{
            Context        = $context
            Environment    = $name
            ApproverId     = "$($group.IdentityId)"
            TimeoutMinutes = $config.timeout_hours * 60
            DryRun         = $DryRun
        }
        $action = Sync-AdoEnvironmentCheck @check
        [pscustomobject]@{
            Kind    = 'Check'
            Target  = $name
            Action  = $action
            Details = "approver $groupName, timeout $($config.timeout_hours) h"
            DryRun  = [bool]$DryRun
        }
    }
}
