<#
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-azure-dev-ops/private/Sync-AdoGraphGroup.ps1.md"
  warning: "Generated Header"
---
#>

function Sync-AdoGraphGroup {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Mandatory)]
        [pscustomobject] $Context,

        [Parameter(Mandatory)]
        [string] $Name,

        [Parameter(Mandatory)]
        [string] $Description,

        [switch] $DryRun
    )

    $groups = @(Invoke-AdoRestMethod -Uri "$($Context.GraphBase)/groups?scopeDescriptor=$($Context.ScopeDescriptor)&api-version=7.1-preview.1")
    $group = $groups | Where-Object { $null -ne $_ -and "$($_.displayName)" -eq $Name } | Select-Object -First 1

    # The group is matched by name; its description is written when the group is created.
    $action = if ($group) {
        'Unchanged'
    }
    else {
        'Create'
    }

    if (-not $DryRun -and $action -eq 'Create') {
        $group = Invoke-AdoRestMethod -Uri "$($Context.GraphBase)/groups?scopeDescriptor=$($Context.ScopeDescriptor)&api-version=7.1-preview.1" -Method Post -Body @{
            displayName = $Name
            description = $Description
        }
        Assert-NotNull $group -ErrorText "Creating group '$Name' in $($Context.Organization)/$($Context.Project) returned nothing."
    }
    Write-Message "$action group '[$($Context.Project)]\$Name'$(if ($DryRun) { ' [dry run]' })"

    # A group a dry run would create has no descriptor or identity yet.
    $descriptor = $null
    $identityId = $null
    if ($group) {
        $descriptor = "$($group.descriptor)"
        $identityId = "$($group.originId)"
    }
    [pscustomobject]@{
        Action     = $action
        Name       = $Name
        Descriptor = $descriptor
        IdentityId = $identityId
    }
}
