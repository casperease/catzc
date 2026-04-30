<#
.SYNOPSIS
    Writes the deployment-provenance tags (commit, buildId, branch) on the target scope.
.DESCRIPTION
    Called by Deploy-Bicep after a successful deploy. Resolves the scope:
    - ResourceGroup target  → `/subscriptions/<id>/resourceGroups/<rg>`
    - Subscription target   → `/subscriptions/<id>`

    Tag *values* come from:
    - Pipeline:  $env:BUILD_SOURCEVERSION / $env:BUILD_BUILDID / $env:BUILD_SOURCEBRANCH
    - Devbox:    Get-GitCurrentCommit / 'CLI_NO_BUILD' / Get-GitCurrentBranch

    Tag *names* are template-aware (see Get-BicepTrackTagNameSet).

    Runs `az tag update --operation Merge` so unrelated tags on the scope are preserved. On a non-zero
    exit it throws a self-contained error that names the target scope, the exact az command, the exit
    code, and az's captured stderr/stdout — so a failure here (e.g. a tag-governing Azure Policy
    colliding with the tags API, or a dropped connection) is diagnosable from the thrown error itself,
    not only from the live console stream.
.PARAMETER Slot
    Optional special-slot discriminator (1-3 lowercase alphanumeric chars). Selects the same slot (and
    therefore the same RG) that was deployed; omitted -> the env's base / index-0 slot.
.PARAMETER Subscription
    Optional subscription (the config folder). Resolved from (env, slot) when omitted; required only when
    more than one subscription serves that env+slot.
.PARAMETER DryRun
    Preview only — log the tag command that would run and make no change.
.EXAMPLE
    Set-BicepTrackingTagSet -Environment dev -Template sample
#>
function Set-BicepTrackingTagSet {
    # State-changing function deliberately uses -DryRun, not ShouldProcess — see
    # docs/adr/automation/prefer-dryrun-over-shouldprocess.md.
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessForStateChangingFunctions', '', Justification = 'Uses -DryRun instead of ShouldProcess — see docs/adr/automation/prefer-dryrun-over-shouldprocess.md#rule-adr-dryrun5')]
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
                Get-BicepTemplateSlots -Template $fakeBoundParameters['Template'] -Environment $fakeBoundParameters['Environment'] -Subscription $fakeBoundParameters['Subscription']
            })]
        [string] $Slot,

        [ArgumentCompleter({
                param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)
                Get-BicepTemplateSubscriptions -Template $fakeBoundParameters['Template'] -Environment $fakeBoundParameters['Environment'] -Slot $fakeBoundParameters['Slot']
            })]
        [string] $Subscription,

        [switch] $DryRun
    )

    $templateDescriptor = Get-BicepTemplate $Template
    $subscription = Resolve-BicepDeploymentSubscription -Template $Template -Environment $Environment -Slot $Slot -Subscription $Subscription
    $environmentDescriptor = Get-AzureEnvironment $Environment -Subscription $subscription
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

    # -NoAssert: take the result in hand so a failure throws WITH context (scope, command, az stderr)
    # from here, rather than the generic exit-code assertion buried in Invoke-Executable. az's stderr is
    # where the real cause shows up — a RequestDisallowedByPolicy / tag-policy collision, a dropped
    # connection, an auth problem — so it must travel in the thrown error, not just the console stream.
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
