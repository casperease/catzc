function Sync-AdoGraphGroupMembers {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Mandatory)]
        [pscustomobject] $Context,

        [Parameter(Mandatory)]
        [pscustomobject] $Group,

        [Parameter(Mandatory)]
        [string[]] $Member,

        [switch] $DryRun
    )

    $wanted = [ordered]@{}
    foreach ($name in $Member) {
        $found = @(Invoke-AdoRestMethod -Uri "$($Context.GraphBase)/subjectquery?api-version=7.1-preview.1" -Method Post -UnwrapValue $true -Body @{
                query = $name; subjectKind = @('User')
            }) | Where-Object { $null -ne $_ -and "$($_.principalName)" -eq $name } | Select-Object -First 1
        Assert-NotNull $found -ErrorText "Approver '$name' is not a user of $($Context.Organization). Fix approver_group.members in environment-approvals.yml."
        $wanted["$($found.descriptor)"] = $name
    }

    $current = @()
    if ($Group.Descriptor) {
        $current = @(Invoke-AdoRestMethod -Uri "$($Context.GraphBase)/Memberships/$($Group.Descriptor)?direction=Down&api-version=7.1-preview.1" |
                Where-Object { $null -ne $_ } | ForEach-Object { "$($_.memberDescriptor)" })
    }

    $add = @($wanted.Keys | Where-Object { $_ -notin $current })
    $remove = @($current | Where-Object { -not $wanted.Contains($_) })

    if (-not $DryRun) {
        foreach ($descriptor in $add) {
            $null = Invoke-AdoRestMethod -Uri "$($Context.GraphBase)/memberships/$descriptor/$($Group.Descriptor)?api-version=7.1-preview.1" -Method Put
        }
        foreach ($descriptor in $remove) {
            $null = Invoke-AdoRestMethod -Uri "$($Context.GraphBase)/memberships/$descriptor/$($Group.Descriptor)?api-version=7.1-preview.1" -Method Delete
        }
    }
    Write-Message "Members of '$($Group.Name)': $($add.Count) to add, $($remove.Count) to remove$(if ($DryRun) { ' [dry run]' })"

    [pscustomobject]@{
        Added   = @($add | ForEach-Object { $wanted[$_] })
        Removed = $remove
    }
}
