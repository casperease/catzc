function Register-AdoBranchPolicies {
    [CmdletBinding()]
    [OutputType([PSCustomObject[]])]
    param(
        [string] $Branch = (Get-Config -Config build-validation).branch,

        [string] $Project = (Get-Config -Config ado)['project'],

        [string] $Organization = (Get-Config -Config ado)['organization'],

        [string] $RepositoryName = (Get-AdoRepositoryName),

        [switch] $DryRun
    )

    Assert-NotNullOrWhitespace $Branch -ErrorText 'Branch is required. Set -Branch or configure build-validation.yml.'
    $policies = (Get-Config -Config build-validation).policies
    $context = Resolve-AdoBuildValidationContext -Project $Project -Organization $Organization -RepositoryName $RepositoryName
    $scope = @(@{ repositoryId = $context.RepositoryId; refName = "refs/heads/$Branch"; matchKind = 'Exact' })

    # The well-known ADO policy types, one policy each; a required-reviewer policy only when the config names reviewers.
    $wanted = [ordered]@{
        'Minimum number of reviewers' = @{
            TypeId   = 'fa4e907d-c16b-4a4c-9dfa-4906e5d171dd'
            Settings = [ordered]@{
                minimumApproverCount = $policies.minimum_reviewers
                creatorVoteCounts    = $policies.creator_vote_counts
                resetOnSourcePush    = $policies.reset_on_push
                allowDownvotes       = $false
            }
        }
        'Require a merge strategy'    = @{
            TypeId   = 'fa4e907d-c16b-4a4c-9dfa-4916e5d171ab'
            Settings = [ordered]@{
                allowSquash        = 'squash' -in $policies.merge_types
                allowNoFastForward = 'no_fast_forward' -in $policies.merge_types
                allowRebase        = 'rebase' -in $policies.merge_types
                allowRebaseMerge   = 'rebase_merge' -in $policies.merge_types
            }
        }
    }
    if ($policies.require_comment_resolution) {
        $wanted['Comment requirements'] = @{ TypeId = 'c6a1889d-b943-4856-b76f-9e46bb6b0df2'; Settings = [ordered]@{} }
    }
    if ($policies.automatic_reviewer_ids.Count -gt 0) {
        $wanted['Required reviewers'] = @{
            TypeId   = 'fd2167ab-b0be-447a-8ec8-39368250530e'
            Settings = [ordered]@{ requiredReviewerIds = @($policies.automatic_reviewer_ids); minimumApproverCount = 1 }
        }
    }

    $existingAll = @(Invoke-AdoRestMethod -Uri "$($context.ApiBase)/policy/configurations?api-version=7.1")
    foreach ($name in $wanted.Keys) {
        $policy = $wanted[$name]
        $settings = [ordered]@{}
        foreach ($key in $policy.Settings.Keys) {
            $settings[$key] = $policy.Settings[$key]
        }
        $settings['scope'] = $scope
        $desired = @{ isEnabled = $true; isBlocking = $true; type = @{ id = $policy.TypeId }; settings = $settings }

        $existing = $existingAll | Where-Object {
            "$($_.type.id)" -eq $policy.TypeId -and @($_.settings.scope | Where-Object { $_.refName -eq "refs/heads/$Branch" -and $_.repositoryId -eq $context.RepositoryId }).Count -gt 0
        } | Select-Object -First 1

        # A setting is current when the server holds the same value under the same name; the scope is matched above.
        $drift = $null -eq $existing -or -not $existing.isEnabled -or -not $existing.isBlocking
        foreach ($key in $policy.Settings.Keys) {
            if ($drift) {
                break
            }
            $have = $existing.settings.PSObject.Properties[$key]
            $drift = $null -eq $have -or ((@($have.Value) -join ',') -ne (@($policy.Settings[$key]) -join ','))
        }
        $action = if ($null -eq $existing) {
            'Create'
        }
        elseif ($drift) {
            'Update'
        }
        else {
            'Unchanged'
        }

        if (-not $DryRun) {
            switch ($action) {
                'Create' {
                    $null = Invoke-AdoRestMethod -Uri "$($context.ApiBase)/policy/configurations?api-version=7.1" -Method Post -Body $desired
                    Write-Message "Created branch policy '$name' on $Branch"
                }
                'Update' {
                    $null = Invoke-AdoRestMethod -Uri "$($context.ApiBase)/policy/configurations/$($existing.id)?api-version=7.1" -Method Put -Body $desired
                    Write-Message "Updated branch policy '$name' (id: $($existing.id)) on $Branch"
                }
                'Unchanged' {
                    Write-Message "Branch policy '$name' on $Branch is already current (id: $($existing.id))"
                }
            }
        }
        [pscustomobject]@{ Policy = $name; Action = $action; Branch = $Branch; Settings = $policy.Settings }
    }
}
