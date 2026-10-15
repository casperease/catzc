<#
---
catzc:
  derived:
    path: automation/Catzc.Azure.Templates/Get-BicepDeploymentContext.ps1
    kind: public-function
    module: Catzc.Azure.Templates
    visibility: public
    adrs:
      - ADR-AZ-DATAMOD
---
#>

<#
.SYNOPSIS
    Composes the immutable deployment-context object Deploy-Bicep operates on.
.DESCRIPTION
    A DoNotRun template returns null, the signal to skip, unless -OverrideDoNotRunAndRun is set.
.PARAMETER Environment
    Environment shortname (must be in azure.yml and in the template's environment list).
.PARAMETER Template
    Template name (folder under infrastructure/templates/).
.PARAMETER Slot
    Omitted selects the environment's base slot, the index-0 one.
.PARAMETER SubscriptionIdAssertIs
    A mismatch in a pipeline means a mis-wired service connection; this is a guard, never a selector.
.PARAMETER ArtifactsFolder
    Required on a build agent. Points at the downloaded build output.
.PARAMETER DoNotRebuild
    Devbox-only. Reuse an existing build in the template's output_folder instead of rebuilding.
.PARAMETER OverrideDoNotRunAndRun
    Devbox-only. Bypass the DoNotRun guard (returns context instead of $null).
.EXAMPLE
    $context = Get-BicepDeploymentContext -Environment dev -Template sample
#>
function Get-BicepDeploymentContext {
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

        [ArgumentCompleter({
                param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)
                Get-BicepTemplateSlots -Template $fakeBoundParameters['Template'] -Environment $fakeBoundParameters['Environment']
            })]
        [string] $Slot,

        [string] $SubscriptionIdAssertIs,

        [string] $ArtifactsFolder,

        [switch] $DoNotRebuild,

        [switch] $OverrideDoNotRunAndRun
    )

    $inPipeline = Test-IsRunningInPipeline

    if ($inPipeline) {
        if ($DoNotRebuild.IsPresent) {
            throw '-DoNotRebuild is devbox-only and cannot be used in a pipeline'
        }
        if ($OverrideDoNotRunAndRun.IsPresent) {
            throw '-OverrideDoNotRunAndRun is devbox-only and cannot be used in a pipeline'
        }
        if ([string]::IsNullOrWhiteSpace($ArtifactsFolder) -or -not (Test-Path $ArtifactsFolder -PathType Container)) {
            throw 'On a build agent the -ArtifactsFolder must point at an existing build output folder'
        }
    }

    $templateDescriptor = Get-BicepTemplate $Template

    if ($Environment -notin $templateDescriptor.environments) {
        throw "Environment '$Environment' is not configured for template '$Template'. Available: $($templateDescriptor.environments -join ', ')"
    }

    if ($templateDescriptor.deployment_mode -eq 'DoNotRun' -and -not $OverrideDoNotRunAndRun.IsPresent) {
        Write-Message "Template '$Template' is marked DoNotRun — skipping"
        return $null
    }

    # A guard mismatch is a mis-wired service connection, not a retarget, so it throws.
    # [comment:4](/docs/references/automation/catzc-azure-templates/Get-BicepDeploymentContext.ps1.md#comment4)
    $sessionSubscription = Get-AzCliSessionSubscription
    if (-not [string]::IsNullOrEmpty($SubscriptionIdAssertIs)) {
        Assert-IsGuid $SubscriptionIdAssertIs
        if ("$($sessionSubscription.id)" -ne $SubscriptionIdAssertIs) {
            throw "-SubscriptionIdAssertIs failed: the az session targets subscription '$($sessionSubscription.name)' ($($sessionSubscription.id)), not $SubscriptionIdAssertIs — in a pipeline this means the service connection is wired to the wrong subscription."
        }
    }
    $subscription = $sessionSubscription.name
    $customer = $sessionSubscription.customer

    # The session subscription must also serve the env, which Get-AzureEnvironment asserts.
    # [comment:5](/docs/references/automation/catzc-azure-templates/Get-BicepDeploymentContext.ps1.md#comment5)
    $wantSlot = [string]$Slot
    $slotMatch = @($templateDescriptor.slots | Where-Object { $_.environment -eq $Environment -and $_.slot -eq $wantSlot -and $_.customer -eq $customer })
    if ($slotMatch.Count -eq 0) {
        $where = if ([string]::IsNullOrEmpty($customer)) {
            'the shared platform (configuration root)'
        }
        else {
            "customer '$customer' (configuration/$customer/)"
        }
        $configName = Get-BicepConfigName $Environment $Slot
        throw "Template '$Template' has no config '$configName.yml' for $where — the az session subscription '$subscription' addresses that coordinate. Configured: $(@($templateDescriptor.slots | ForEach-Object { if ($_.customer) { "$($_.customer)/$($_.name)" } else { $_.name } } | Sort-Object) -join ', ')"
    }
    $environmentDescriptor = Get-AzureEnvironment $Environment -Subscription $subscription
    $configurationDescriptor = Get-BicepTemplateConfiguration $Template $Environment -Slot $Slot -Customer $customer

    $resourceGroup = $null
    switch ($templateDescriptor.deployment_target) {
        'ResourceGroup' {
            # Derived from the (customer, env, slot) + naming standard — never hand-typed.
            $resourceGroup = Get-BicepResourceGroupName -Template $Template -Environment $Environment -Slot $Slot -Customer $customer
        }
        'Subscription' {
            if ($configurationDescriptor.Contains('ResourceGroup')) {
                throw "Template '$Template' is Subscription-target but its config carries a 'ResourceGroup' key — remove it (subscription-scoped deployments have no RG)"
            }
        }
        default {
            throw "Unsupported deployment_target '$($templateDescriptor.deployment_target)' for template '$Template'"
        }
    }

    $didLocalBuild = $false
    $buildFolder = if ($inPipeline) {
        $ArtifactsFolder
    }
    elseif ($DoNotRebuild.IsPresent) {
        $templateDescriptor.output_folder
    }
    else {
        $built = Build-Bicep -Template $Template -Environments @($Environment)
        $didLocalBuild = $true
        $built
    }

    if (-not (Test-Path $buildFolder -PathType Container)) {
        throw "No template build found at '$buildFolder' (run Build-Bicep first, or omit -DoNotRebuild)"
    }

    $templateFile = Join-Path $buildFolder 'main.json'
    Assert-PathExist $templateFile -PathType Leaf
    $parametersFile = Join-Path $buildFolder (Get-BicepParametersFileName -Environment $Environment -Slot $Slot -Customer $customer)
    Assert-PathExist $parametersFile -PathType Leaf

    $deployment = [Catzc.Azure.Templates.BicepDeploymentPlan]::new(
        $Template,
        (Get-BicepDeploymentName $Template -Environment $Environment -Slot $Slot),
        $templateDescriptor.deployment_mode,
        $templateDescriptor.deployment_target,
        $resourceGroup)   # $null for Subscription-target — the plan exposes resource_group = $null

    # Paths are verified absolute but stored repo-relative; a pipeline's external artifact area stays absolute.
    # [comment:6](/docs/references/automation/catzc-azure-templates/Get-BicepDeploymentContext.ps1.md#comment6)
    $prepostArtifact = $null
    if ($null -ne $templateDescriptor.prepost_module) {
        $prepostInBuild = Join-Path $buildFolder (Split-Path $templateDescriptor.prepost_module -Leaf)
        Assert-PathExist $prepostInBuild -PathType Leaf
        $prepostArtifact = ConvertTo-RepoRelativePath $prepostInBuild
    }
    $artifacts = [Catzc.Azure.Templates.BicepArtifacts]::new(
        $didLocalBuild,
        (ConvertTo-RepoRelativePath $buildFolder),
        (ConvertTo-RepoRelativePath $templateFile),
        (ConvertTo-RepoRelativePath $parametersFile),
        $prepostArtifact)

    [Catzc.Azure.Templates.BicepDeploymentContext]::new($deployment, $artifacts, $environmentDescriptor)
}
