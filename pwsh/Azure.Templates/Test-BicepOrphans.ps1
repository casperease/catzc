function Test-BicepOrphans {
    [CmdletBinding()]
    [OutputType([Catzc.Base.Reports.QualityGateResult])]
    param(
        [string] $OutputFolder,

        [switch] $PassThru
    )

    # The az session decides the subscription, as for a deploy; only its resource groups are compared.
    $session = Get-AzCliSessionSubscription
    $org = (Get-Config -Config azure).org

    $expected = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::OrdinalIgnoreCase)
    $special = [System.Collections.Generic.List[string]]::new()
    foreach ($template in Get-BicepTemplateNames) {
        $descriptor = Get-BicepTemplate $template
        foreach ($slot in @($descriptor.slots | Where-Object { $_.subscription -eq $session.name })) {
            if ($descriptor.deployment_target -eq 'ResourceGroup') {
                $null = $expected.Add((Get-BicepResourceGroupName -Template $template -Environment $slot.environment -Slot $slot.slot -Customer $slot.customer))
            }
            # A named slot is a special one (a blue/green or a trial copy): it is reported so it is removed when its job is done.
            if (-not [string]::IsNullOrEmpty($slot.slot)) {
                $special.Add("$template/$(if ($slot.customer) { "$($slot.customer)/" })$($slot.name)")
            }
        }
    }

    # A resource group is catzc's when its name carries the org segment and the rg suffix, as every derived name does.
    $groups = @((Invoke-AzCli 'group list -o json' -PassThru -Silent).Output | ConvertFrom-Json)
    $ours = @($groups | Where-Object { $_.name -like "*-$org-*-rg" })
    $issues = [System.Collections.Generic.List[string]]::new()
    foreach ($group in $ours | Sort-Object name) {
        if (-not $expected.Contains($group.name)) {
            $issues.Add("resource group '$($group.name)' in subscription '$($session.name)' has no template config — remove it, or add the config it was deployed from")
        }
    }

    Write-QualityGateReport -Subject 'bicep-orphans' -Title 'Test-BicepOrphans' -Issues $issues `
        -Facts ([ordered]@{
            Subscription   = $session.name
            Groups         = $ours.Count
            Expected       = $expected.Count
            SpecialSlots   = $special.Count
            RemoveWhenDone = ($special -join ', ')
        }) `
        -OutputFolder $OutputFolder -PassThru:$PassThru
}
