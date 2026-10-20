<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Azure.DevOps/private/Sync-AdoGraphGroup.ps1
    folder: private
    name: sync-ado-graph-group
    filetype: ps1
    role: function
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Azure.DevOps
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: private
  edges:
    test: pwsh/Catzc.Azure.DevOps/tests/Sync-AdoGraphGroup.Tests.ps1
    docs: "[Sync-AdoGraphGroup.ps1.md](docs/references/pwsh/catzc-azure-devops/private/Sync-AdoGraphGroup.ps1.md)"
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
