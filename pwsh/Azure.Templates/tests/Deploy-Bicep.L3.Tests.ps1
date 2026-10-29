Describe 'Deploy-Bicep to an ephemeral l3 slot (live Azure)' -Tag 'L3', 'integrity' {
    BeforeAll {
        # The session's subscription is the one target a deploy may take; without a session the test proves nothing and skips.
        $script:session = try {
            Get-AzCliSessionSubscription
        }
        catch {
            $null
        }
        $script:created = [System.Collections.Generic.List[pscustomobject]]::new()
        # Each resource-group template's non-production base slot on the session's subscription, deployed again as the ephemeral slot l3.
        $script:targets = @(if ($session) {
                foreach ($name in @(Get-BicepTemplateNames)) {
                    $descriptor = Get-BicepTemplate $name
                    if ($descriptor.deployment_target -ne 'ResourceGroup') {
                        continue
                    }
                    $base = @($descriptor.slots | Where-Object {
                            $_.slot -eq '' -and $_.subscription -eq $session.name -and
                            -not (Get-Config -Config azure).environments[$_.environment].production
                        }) | Select-Object -First 1
                    if ($base) {
                        [pscustomobject]@{ Template = $name; Environment = $base.environment; Customer = $base.customer }
                    }
                }
            })
    }

    AfterAll {
        # Every group the test made goes, whatever the assertions said; a group it leaves is one Test-BicepOrphans reports.
        foreach ($group in $script:created) {
            Invoke-AzCli "group delete --name `"$($group.Name)`" --subscription $($group.Subscription) --yes" -NoAssert | Out-Null
        }
    }

    It 'deploys each template to l3, tags its resource group with where it came from, and leaves no group behind' {
        if (-not $session) {
            Set-ItResult -Skipped -Because 'no_az_session'
            return
        }
        if ($targets.Count -eq 0) {
            Set-ItResult -Skipped -Because "no_non_production_base_slot_on_$($session.name)"
            return
        }
        foreach ($target in $targets) {
            # The context builds the l3 slot and names its group, the base slot's declared group re-rendered for l3.
            $group = (Get-BicepDeploymentContext -Environment $target.Environment -Template $target.Template -Slot l3).deployment.resource_group
            $script:created.Add([pscustomobject]@{ Name = $group; Subscription = $session.id })
            Deploy-Bicep -Environment $target.Environment -Template $target.Template -Slot l3 -DoNotRebuild
            $tags = (Invoke-AzCli "group show --name `"$group`" --subscription $($session.id) --query tags --output json" -PassThru).Output | ConvertFrom-Json -AsHashtable
            $names = Get-BicepTrackTagNameSet $target.Template
            $tags.Contains($names.commit) | Should -BeTrue -Because "the l3 group of $($target.Template) records its commit"
            $tags[$names.branch] | Should -Be 'devbox' -Because 'a devbox deploy records devbox, never a branch name'
            foreach ($key in @((Get-Config -Config azure).tags.keys.Keys)) {
                $tags.Contains($key) | Should -BeTrue -Because "the l3 group of $($target.Template) carries the CAF tag $key"
            }
        }
    }
}
