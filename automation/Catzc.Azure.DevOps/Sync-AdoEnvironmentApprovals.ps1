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
    $Organization = $Organization.TrimEnd('/')
    $identityBase = $Organization -replace '^https://dev\.azure\.com/', 'https://vssps.dev.azure.com/'
    Assert-True ($identityBase -ne $Organization) -ErrorText "Organization '$Organization' is not a https://dev.azure.com/<org> URL, so its identity service cannot be named."

    # The Approval check type of Azure Pipelines: a fixed id of the ADO service, not a setting.
    $approvalTypeId = '8c6f20a7-a545-4486-9777-f762fafe0d4d'
    $config = Get-Config -Config environment-approvals
    $apiBase = "$Organization/$Project/_apis"
    $groupName = "[$Project]\$($config.approver_group)"
    $timeoutMinutes = $config.timeout_hours * 60

    $identities = @(Invoke-AdoRestMethod -Uri "$identityBase/_apis/identities?searchFilter=General&filterValue=$([uri]::EscapeDataString($groupName))&api-version=7.1")
    $group = $identities | Where-Object { $_.providerDisplayName -eq $groupName } | Select-Object -First 1
    Assert-NotNull $group -ErrorText "Approver group '$groupName' does not exist in $Organization. Create it in Azure DevOps, or set approver_group in environment-approvals.yml."

    foreach ($name in $config.environments) {
        $environment = @(Invoke-AdoRestMethod -Uri "$apiBase/distributedtask/environments?name=$([uri]::EscapeDataString($name))&api-version=7.1") |
            Where-Object { $_.name -eq $name } | Select-Object -First 1
        Assert-NotNull $environment -ErrorText "Environment '$name' does not exist in $Organization/$Project. A CD run creates it on its first deploy, or create it in Azure DevOps."

        $checks = @(Invoke-AdoRestMethod -Uri "$apiBase/pipelines/checks/configurations?resourceType=environment&resourceId=$($environment.id)&`$expand=settings&api-version=7.1-preview.1")
        $existing = $checks | Where-Object { $null -ne $_ -and $_.PSObject.Properties['type'] -and "$($_.type.id)" -eq $approvalTypeId } |
            Select-Object -First 1

        $desired = @{
            type     = @{ id = $approvalTypeId; name = 'Approval' }
            settings = @{
                approvers                 = @(@{ id = $group.id })
                executionOrder            = 1
                minRequiredApprovers      = 1
                requesterCannotBeApprover = $false
                blockedApprovers          = @()
                instructions              = "Approve the deploy to $name."
            }
            resource = @{ type = 'environment'; id = "$($environment.id)"; name = $name }
            timeout  = $timeoutMinutes
        }

        $action = if (-not $existing) {
            'Create'
        }
        elseif ((@($existing.settings.approvers | ForEach-Object { "$($_.id)" }) -join ',') -ne "$($group.id)" -or
            [int]$existing.timeout -ne $timeoutMinutes) {
            'Update'
        }
        else {
            'Unchanged'
        }

        if (-not $DryRun) {
            if ($action -eq 'Create') {
                $null = Invoke-AdoRestMethod -Uri "$apiBase/pipelines/checks/configurations?api-version=7.1-preview.1" -Method Post -Body $desired
            }
            elseif ($action -eq 'Update') {
                $null = Invoke-AdoRestMethod -Uri "$apiBase/pipelines/checks/configurations/$($existing.id)?api-version=7.1-preview.1" -Method Patch -Body $desired
            }
        }
        Write-Message "$action approval on '$name' (approver $groupName, timeout $($config.timeout_hours) h)$(if ($DryRun) { ' [dry run]' })"

        [pscustomobject]@{
            Environment   = $name
            Action        = $action
            ApproverGroup = $groupName
            TimeoutHours  = $config.timeout_hours
            DryRun        = [bool]$DryRun
        }
    }
}
