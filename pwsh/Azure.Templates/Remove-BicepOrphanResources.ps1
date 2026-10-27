function Remove-BicepOrphanResources {
    # A state-changing command that previews with -DryRun, not ShouldProcess.
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessForStateChangingFunctions', '',
        Justification = 'Uses -DryRun instead of ShouldProcess — see ADR-PWSH-DRYRUN-SUPPRESSSHOULDPROCESS')]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '',
        Justification = 'ArgumentCompleter scriptblocks require PowerShell''s fixed 5-parameter completer signature; only $fakeBoundParameters is used, but the other four are mandatory and cannot be removed')]
    [CmdletBinding()]
    [OutputType([string[]])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [ArgumentCompleter({ (Get-Config -Config azure).environments.Keys })]
        [ValidateScript({ $_ -in (Get-Config -Config azure).environments.Keys })]
        [string] $Environment,

        [Parameter(Mandatory, Position = 1)]
        [ArgumentCompleter({ Get-BicepTemplateNames })]
        [ValidateScript({ $_ -in (Get-BicepTemplateNames) })]
        [string] $Template,

        [ArgumentCompleter({
                param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)
                Get-BicepTemplateSlots -Template $fakeBoundParameters['Template'] -Environment $fakeBoundParameters['Environment']
            })]
        [string] $Slot,

        [string] $SubscriptionIdAssertIs,

        [string] $ArtifactsFolder,

        [switch] $DryRun
    )

    if ((Test-IsRunningInPipeline) -and [string]::IsNullOrEmpty($SubscriptionIdAssertIs)) {
        throw "Remove-BicepOrphanResources requires -SubscriptionIdAssertIs in a pipeline — the pipeline must pin the subscription GUID its service connection is expected to target, for template '$Template' ($Environment)."
    }

    # The same resolved identity Deploy-Bicep deploys with: the session's subscription, the slot's resource group and the artifacts.
    $context = Get-BicepDeploymentContext -Environment $Environment -Template $Template -Slot $Slot -SubscriptionIdAssertIs $SubscriptionIdAssertIs -ArtifactsFolder $ArtifactsFolder
    if ($null -eq $context) {
        Write-Message "Skipping orphan removal for '$Template' ($Environment) — DoNotRun"
        return
    }
    if ($context.deployment.target -ne 'ResourceGroup') {
        throw "Remove-BicepOrphanResources compares one resource group with its template, but '$Template' deploys at $($context.deployment.target) scope, which several templates share."
    }
    $group = $context.deployment.resource_group
    $subscriptionId = $context.environment.subscription.id

    # The template's evaluated resources, read with the slot's own parameter values, as the template-compliance quality gate reads them.
    $main = [System.IO.File]::ReadAllText((Resolve-RepoPath $context.artifacts.template_file)) | ConvertFrom-Json -AsHashtable
    $parameters = [System.IO.File]::ReadAllText((Resolve-RepoPath $context.artifacts.parameters_file)) | ConvertFrom-Json -AsHashtable
    $values = @{}
    if ($parameters -is [System.Collections.IDictionary] -and $parameters.Contains('parameters')) {
        foreach ($parameter in @($parameters.parameters.Keys)) {
            $entry = $parameters.parameters[$parameter]
            $values[$parameter] = if ($entry -is [System.Collections.IDictionary] -and $entry.Contains('value')) {
                $entry.value
            }
            else {
                [Catzc.Azure.Templates.ArmExpression]::Unresolved
            }
        }
    }
    $expected = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::OrdinalIgnoreCase)
    $unresolvedNames = [System.Collections.Generic.List[string]]::new()
    foreach ($item in @(Get-ArmDeployedResource -Template $main -Values $values -Location $context.environment.region)) {
        # Only what az resource list returns is compared: never an extension resource (one with a scope) nor a child proxy (a child without a location).
        if ($item.Resource.Contains('scope') -or (($item.Type -split '/').Count -gt 2 -and -not $item.Resource.Contains('location'))) {
            continue
        }
        if ($item.Name -is [string]) {
            [void]$expected.Add("$($item.Type)|$($item.Name)")
        }
        else {
            $unresolvedNames.Add("$($item.Path) ($($item.Type))")
        }
    }

    $listing = Invoke-AzCli "resource list --subscription $subscriptionId --resource-group $group --output json" -PassThru -NoAssert -Silent
    if ($listing.ExitCode -ne 0) {
        throw "Listing the resources of resource group $group failed (subscription $subscriptionId, az exit code $($listing.ExitCode)): $($listing.Errors)"
    }
    $deployed = @("$($listing.Output)" | ConvertFrom-Json -AsHashtable)
    # A resource Azure creates itself, such as a SQL server's master database, is never a template's, so the declared list skips it.
    $config = Get-Config -Config orphan-removal
    $orphans = @(foreach ($resource in $deployed) {
            if ($null -ne $resource -and -not $expected.Contains("$($resource.type)|$($resource.name)") -and -not $config.IsAzureCreated("$($resource.type)", "$($resource.name)")) {
                "$($resource.id)"
            }
        })

    # An unresolved name could match any deployed resource, so a deletion is refused and the candidates are only listed (ADR-AZ-DATAMOD-ORPHANSNEEDRESOLVEDNAMES).
    if ($unresolvedNames.Count -gt 0) {
        $orphans
        throw "Remove-BicepOrphanResources lists $($orphans.Count) candidates in resource group $group but deletes none: the names of $($unresolvedNames.Count) listable resources of '$Template' do not resolve offline: $($unresolvedNames -join ', ')."
    }
    if ($orphans.Count -eq 0) {
        Write-Message "Resource group $group holds nothing the template '$Template' no longer declares"
        return
    }
    if ($DryRun) {
        return $orphans
    }
    foreach ($id in $orphans) {
        $deletion = Invoke-AzCli "resource delete --ids `"$id`" --output none" -PassThru -NoAssert -Silent
        if ($deletion.ExitCode -ne 0) {
            throw "Deleting $id failed (resource group $group, az exit code $($deletion.ExitCode)): $($deletion.Errors)"
        }
        Write-Message "Deleted $id, which the template '$Template' no longer declares"
        $id
    }
}
