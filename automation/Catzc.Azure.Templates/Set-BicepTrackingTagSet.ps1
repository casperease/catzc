<#
---
catzc:
  derived:
    path: automation/Catzc.Azure.Templates/Set-BicepTrackingTagSet.ps1
    kind: function
    module: Catzc.Azure.Templates
    visibility: public
    adrs:
      - ADR-AUTO-DRYRUN
      - ADR-PWSH-DRYRUN#1
---
#>

<#
.SYNOPSIS
    Writes the deployment-provenance tags (commit, buildId, branch) on the target scope.
.DESCRIPTION
    The tags land in the az session's subscription, the same target Deploy-Bicep just deployed into.
    [comment:1](/docs/references/automation/catzc-azure-templates/Set-BicepTrackingTagSet.ps1.md#comment1)
.PARAMETER Environment
    The environment the template was deployed to, as azure.yml names it.
.PARAMETER Template
    The Bicep template that was deployed, by name.
.PARAMETER Slot
    Selects the same slot, and so the same resource group, that was deployed; omitted is the base slot.
    [comment:2](/docs/references/automation/catzc-azure-templates/Set-BicepTrackingTagSet.ps1.md#comment2)
.PARAMETER DryRun
    Preview only — log the tag command that would run and make no change.
.EXAMPLE
    Set-BicepTrackingTagSet -Environment dev -Template sample
#>
function Set-BicepTrackingTagSet {
    # -DryRun replaces ShouldProcess here, so the analyzer rule for state-changing functions is suppressed.
    # [ADR-AUTO-DRYRUN](/docs/adr/automation/dry-run.md)
    # [comment:3](/docs/references/automation/catzc-azure-templates/Set-BicepTrackingTagSet.ps1.md#comment3)
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessForStateChangingFunctions', '', Justification = 'Uses -DryRun instead of ShouldProcess — see ADR-PWSH-DRYRUN#1')]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'ArgumentCompleter scriptblocks require PowerShell''s fixed 5-parameter completer signature; only $fakeBoundParameters is used, but the other four are mandatory and cannot be removed')]
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        [ArgumentCompleter({ (Get-Config -Config azure).environments.Keys })]
        [ValidateScript({ $_ -in (Get-Config -Config azure).environments.Keys })]
        [string] $Environment,

        [Parameter(Mandatory, Position = 1)]
        [ArgumentCompleter({ Get-BicepTemplateNames })]
        [ValidateScript({ $_ -in (Get-BicepTemplateNames) })]
        [string] $Template,

        [Parameter(Position = 2)]
        [ArgumentCompleter({
                param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)
                Get-BicepTemplateSlots -Template $fakeBoundParameters['Template'] -Environment $fakeBoundParameters['Environment']
            })]
        [string] $Slot,

        [switch] $DryRun
    )

    $templateDescriptor = Get-BicepTemplate $Template
    # The scope is the az session's subscription — the same session-determined target the deploy used.
    $sessionSubscription = Get-AzCliSessionSubscription
    $environmentDescriptor = Get-AzureEnvironment $Environment -Subscription $sessionSubscription.name
    $customer = if ($null -ne $environmentDescriptor.subscription.customer) {
        $environmentDescriptor.subscription.customer
    }
    else {
        ''
    }

    $tagValues = if (Test-IsRunningInPipeline) {
        Assert-NotNullOrWhitespace $env:BUILD_SOURCEVERSION
        Assert-NotNullOrWhitespace $env:BUILD_BUILDID
        Assert-NotNullOrWhitespace $env:BUILD_SOURCEBRANCH
        [ordered]@{
            commit   = $env:BUILD_SOURCEVERSION
            build_id = $env:BUILD_BUILDID
            branch   = $env:BUILD_SOURCEBRANCH
        }
    }
    else {
        [ordered]@{
            commit   = Get-GitCurrentCommit
            build_id = 'CLI_NO_BUILD'
            branch   = Get-GitCurrentBranch
        }
    }

    $subscriptionId = $environmentDescriptor.subscription.id
    $resourceId = if ($templateDescriptor.deployment_target -eq 'Subscription') {
        "/subscriptions/$subscriptionId"
    }
    else {
        $resourceGroup = Get-BicepResourceGroupName -Template $Template -Environment $Environment -Slot $Slot -Customer $customer
        "/subscriptions/$subscriptionId/resourceGroups/$resourceGroup"
    }

    $tagNames = Get-BicepTrackTagNameSet $Template
    $tagArgs = foreach ($key in $tagNames.Keys) {
        "$($tagNames[$key])=$($tagValues[$key])"
    }

    $command = "tag update --operation Merge --resource-id $resourceId --output yaml --tags $($tagArgs -join ' ')"

    if ($DryRun) {
        Write-Message "DryRun: $command"
        return
    }

    # -NoAssert lets a failed tag call throw with scope, command and az stderr, where a policy collision shows up.
    # [comment:4](/docs/references/automation/catzc-azure-templates/Set-BicepTrackingTagSet.ps1.md#comment4)
    $result = Invoke-AzCli $command -PassThru -NoAssert
    if ($result.ExitCode -ne 0) {
        $detail = @(
            "Failed to write tracking tags on scope '$resourceId' (az tag update exited $($result.ExitCode))."
            "command : az $command"
            "stderr  : $($result.Errors)"
            "stdout  : $($result.Output)"
        ) -join [Environment]::NewLine
        throw $detail
    }

    $result.Output | ConvertFrom-Yaml
}
