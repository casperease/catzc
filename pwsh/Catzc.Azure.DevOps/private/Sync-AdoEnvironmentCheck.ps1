<#
---
catzc:
  immutable:
    with_body_sha: e76abb9acb07
  edges:
    test: pwsh/Catzc.Azure.DevOps/tests/Sync-AdoEnvironmentCheck.Tests.ps1
    docs: "[Sync-AdoEnvironmentCheck.ps1.md](docs/references/pwsh/catzc-azure-dev-ops/private/Sync-AdoEnvironmentCheck.ps1.md)"
---
#>

function Sync-AdoEnvironmentCheck {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Mandatory)]
        [pscustomobject] $Context,

        [Parameter(Mandatory)]
        [string] $Environment,

        [AllowEmptyString()]
        [string] $ApproverId,

        [Parameter(Mandatory)]
        [int] $TimeoutMinutes,

        [switch] $DryRun
    )

    # The Approval check type of Azure Pipelines: a fixed id of the ADO service, not a setting.
    $approvalTypeId = '8c6f20a7-a545-4486-9777-f762fafe0d4d'

    $record = @(Invoke-AdoRestMethod -Uri "$($Context.ApiBase)/distributedtask/environments?name=$([uri]::EscapeDataString($Environment))&api-version=7.1") |
        Where-Object { $null -ne $_ -and "$($_.name)" -eq $Environment } | Select-Object -First 1

    $environmentAction = 'Unchanged'
    if (-not $record) {
        $environmentAction = 'Create'
        if (-not $DryRun) {
            $body = @{ name = $Environment; description = 'Created by Sync-AdoEnvironmentApprovals from environment-approvals.yml.' }
            $record = Invoke-AdoRestMethod -Uri "$($Context.ApiBase)/distributedtask/environments?api-version=7.1" -Method Post -Body $body
            Assert-NotNull $record -ErrorText "Creating environment '$Environment' in $($Context.Organization)/$($Context.Project) returned nothing."
        }
        Write-Message "Create environment '$Environment'$(if ($DryRun) { ' [dry run]' })"
    }

    # A new environment has no checks yet.
    $existing = $null
    if ($environmentAction -eq 'Unchanged') {
        $checks = @(Invoke-AdoRestMethod -Uri "$($Context.ApiBase)/pipelines/checks/configurations?resourceType=environment&resourceId=$($record.id)&`$expand=settings&api-version=7.1-preview.1")
        $existing = $checks | Where-Object { $null -ne $_ -and $_.PSObject.Properties['type'] -and "$($_.type.id)" -eq $approvalTypeId } |
            Select-Object -First 1
    }

    $action = if (-not $existing) {
        'Create'
    }
    elseif ((@($existing.settings.approvers | ForEach-Object { "$($_.id)" }) -join ',') -ne $ApproverId -or [int]$existing.timeout -ne $TimeoutMinutes) {
        'Update'
    }
    else {
        'Unchanged'
    }

    if (-not $DryRun -and $action -ne 'Unchanged') {
        Assert-NotNullOrWhitespace $ApproverId -ErrorText "No approver id for the check on '$Environment'."
        $desired = @{
            type     = @{ id = $approvalTypeId; name = 'Approval' }
            settings = @{
                approvers                 = @(@{ id = $ApproverId })
                executionOrder            = 1
                minRequiredApprovers      = 1
                requesterCannotBeApprover = $false
                blockedApprovers          = @()
                instructions              = "Approve the deploy to $Environment."
            }
            resource = @{ type = 'environment'; id = "$($record.id)"; name = $Environment }
            timeout  = $TimeoutMinutes
        }
        if ($action -eq 'Create') {
            $null = Invoke-AdoRestMethod -Uri "$($Context.ApiBase)/pipelines/checks/configurations?api-version=7.1-preview.1" -Method Post -Body $desired
        }
        else {
            $null = Invoke-AdoRestMethod -Uri "$($Context.ApiBase)/pipelines/checks/configurations/$($existing.id)?api-version=7.1-preview.1" -Method Patch -Body $desired
        }
    }
    Write-Message "$action approval check on '$Environment'$(if ($DryRun) { ' [dry run]' })"
    [pscustomobject]@{ Environment = $environmentAction; Check = $action }
}
