<#
.SYNOPSIS
    Deploys a bicep template to Azure (resolves context, runs hooks, calls az, sets tags).
.DESCRIPTION
    The deploy target is the az session's subscription — in a pipeline, exactly what the service connection logged...
    [ADR-AZ-DATAMOD](/docs/adr/azure/azure-data-model.md), [ADR-AUTO-DRYRUN](/docs/adr/automation/dry-run.md)
    [comment:1](/docs/references/automation/catzc-azure-templates/Deploy-Bicep.ps1.md#comment1)
.PARAMETER Environment
    Environment shortname.
.PARAMETER Template
    Template name.
.PARAMETER Slot
    Optional special-slot discriminator (1-3 lowercase alphanumeric chars, `001`).
    [comment:2](/docs/references/automation/catzc-azure-templates/Deploy-Bicep.ps1.md#comment2)
.PARAMETER SubscriptionIdAssertIs
    Guard — the subscription GUID the az session is expected to target; throws on a mismatch (a mis-wired service...
    [comment:3](/docs/references/automation/catzc-azure-templates/Deploy-Bicep.ps1.md#comment3)
.PARAMETER ArtifactsFolder
    Required in a pipeline. Devbox callers can pass it with -DoNotRebuild to skip the local build.
.PARAMETER DoNotRebuild
    Devbox-only. Reuse the existing build instead of rebuilding.
.PARAMETER OverrideDoNotRunAndRun
    Devbox-only. Bypass the template's DoNotRun mode.
.PARAMETER DryRun
    Preview only — runs the Azure `--what-if` deployment and skips the real deploy, post-deploy hook, and tag-setting.
    [comment:4](/docs/references/automation/catzc-azure-templates/Deploy-Bicep.ps1.md#comment4)
.EXAMPLE
    Deploy-Bicep dev sample            # deploys into the az session's subscription
.EXAMPLE
    Deploy-Bicep dev sample -DryRun
.EXAMPLE
    Deploy-Bicep nsub foundation -SubscriptionIdAssertIs a0e00000-de00-50b0-0000-000000000000
#>
function Deploy-Bicep {
    # State-changing function deliberately uses -DryRun, not ShouldProcess — see.
    # [ADR-AUTO-DRYRUN](/docs/adr/automation/dry-run.md)
    # [comment:5](/docs/references/automation/catzc-azure-templates/Deploy-Bicep.ps1.md#comment5)
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

        [ArgumentCompleter({
                param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)
                Get-BicepTemplateSlots -Template $fakeBoundParameters['Template'] -Environment $fakeBoundParameters['Environment']
            })]
        [string] $Slot,

        [string] $SubscriptionIdAssertIs,

        [string] $ArtifactsFolder,
        [switch] $DoNotRebuild,
        [switch] $OverrideDoNotRunAndRun,
        [switch] $DryRun
    )

    # In a pipeline the target MUST be pinned explicitly — the session (the service connection) selects it, and the...
    # [ADR-AZ-DATAMOD](/docs/adr/azure/azure-data-model.md)
    # [comment:6](/docs/references/automation/catzc-azure-templates/Deploy-Bicep.ps1.md#comment6)
    if ((Test-IsRunningInPipeline) -and [string]::IsNullOrEmpty($SubscriptionIdAssertIs)) {
        throw "Deploy-Bicep requires -SubscriptionIdAssertIs in a pipeline — the pipeline must pin the subscription GUID its service connection is expected to target, for template '$Template' ($Environment)."
    }

    # The session determines the target; the context resolves and guards it (Get-AzCliSessionSubscription +...
    # [comment:7](/docs/references/automation/catzc-azure-templates/Deploy-Bicep.ps1.md#comment7)
    $context = Get-BicepDeploymentContext `
        -Environment $Environment `
        -Template $Template `
        -Slot $Slot `
        -SubscriptionIdAssertIs $SubscriptionIdAssertIs `
        -ArtifactsFolder $ArtifactsFolder `
        -DoNotRebuild:$DoNotRebuild `
        -OverrideDoNotRunAndRun:$OverrideDoNotRunAndRun

    if ($null -eq $context) {
        Write-Message "Skipping deployment for '$Template' ($Environment) — DoNotRun"
        return
    }

    Write-Object $context -Name 'deployment context'

    $subscription = $context.environment.subscription.name
    $customerFromContext = if ($null -ne $context.environment.subscription.customer) {
        $context.environment.subscription.customer
    }
    else {
        ''
    }
    $templateDescriptor = Get-BicepTemplate $Template
    $configurationDescriptor = Get-BicepTemplateConfiguration $Template $Environment -Slot $Slot -Customer $customerFromContext

    # A template MAY ship infrastructure/templates/<name>/PrePost.psm1 exporting Invoke-BicepPreDeploy /...
    # [comment:8](/docs/references/automation/catzc-azure-templates/Deploy-Bicep.ps1.md#comment8)
    $preDeployHook = $null
    $postDeployHook = $null
    if ($null -ne $context.artifacts.prepost_module) {
        Write-Message "Importing per-template PrePost: $($context.artifacts.prepost_module)"
        $prepostModule = Import-Module (Resolve-RepoPath $context.artifacts.prepost_module) -Scope Local -Force -PassThru
        # The template's hooks run strict like every catzc module, whoever wrote them.
        # [ADR-PWSH-ERROR#8](/docs/adr/pwsh/error-handling.md#rule-adr-pwsh-error8)
        # [comment:9](/docs/references/automation/catzc-azure-templates/Deploy-Bicep.ps1.md#comment9)
        . $prepostModule { Set-StrictMode -Version Latest }
        if ($prepostModule.ExportedCommands.ContainsKey('Invoke-BicepPreDeploy')) {
            $preDeployHook = $prepostModule.ExportedCommands['Invoke-BicepPreDeploy']
        }
        if ($prepostModule.ExportedCommands.ContainsKey('Invoke-BicepPostDeploy')) {
            $postDeployHook = $prepostModule.ExportedCommands['Invoke-BicepPostDeploy']
        }
    }

    # The deploy invocation — the arguments this deploy is acting on (incl.
    # [ADR-PWSH-PREPOST](/docs/adr/pwsh/prepost-extension-modules.md)
    # [comment:10](/docs/references/automation/catzc-azure-templates/Deploy-Bicep.ps1.md#comment10)
    $deployInvocation = [ordered]@{
        Template     = $Template
        Environment  = $Environment
        Slot         = $Slot
        Subscription = $subscription
        Customer     = $customerFromContext
        Mode         = $context.deployment.mode
    }
    $hookSplat = [ordered]@{
        DeployInvocation        = $deployInvocation
        TemplateDescriptor      = $templateDescriptor
        ConfigurationDescriptor = $configurationDescriptor
        EnvironmentDescriptor   = $context.environment
    }

    # PreDeploy runs before the --what-if branch, so it gets -DryRun and must honor it.
    # [comment:11](/docs/references/automation/catzc-azure-templates/Deploy-Bicep.ps1.md#comment11)
    if ($preDeployHook) {
        & $preDeployHook @hookSplat -DryRun:$DryRun
    }

    if ($context.deployment.target -eq 'ResourceGroup') {
        Deploy-AzureResourceGroup -SubscriptionId $context.environment.subscription.id -Region $context.environment.region -ResourceGroup $context.deployment.resource_group -DryRun:$DryRun | Out-Null
    }

    # The artifact paths are repo-relative where possible (absolute for external pipeline artifacts).
    # [comment:12](/docs/references/automation/catzc-azure-templates/Deploy-Bicep.ps1.md#comment12)
    $templateFile = $context.artifacts.template_file
    $parametersFile = $context.artifacts.parameters_file

    $baseCommand = if ($context.deployment.target -eq 'ResourceGroup') {
        @(
            'deployment group create',
            "--name `"$($context.deployment.name)`"",
            "--subscription $($context.environment.subscription.id)",
            "--resource-group $($context.deployment.resource_group)",
            "--template-file `"$templateFile`"",
            "--parameters `"@$parametersFile`"",
            "--mode $($context.deployment.mode)",
            '--output yaml'
        ) -join ' '
    }
    else {
        @(
            'deployment sub create',
            "--name `"$($context.deployment.name)`"",
            "--location $($context.environment.region)",
            "--template-file `"$templateFile`"",
            "--parameters `"@$parametersFile`"",
            '--output yaml'
        ) -join ' '
    }

    # -NoAssert on the az deployment calls: a non-zero exit throws WITH context (the deployment name, the exact az...
    # [comment:13](/docs/references/automation/catzc-azure-templates/Deploy-Bicep.ps1.md#comment13)
    if ($DryRun) {
        Write-Message 'DryRun: running az --what-if preview'
        $whatIf = Invoke-AzCli "$baseCommand --what-if" -PassThru -NoAssert
        if ($whatIf.ExitCode -ne 0) {
            throw (@(
                    "What-if preview for '$($context.deployment.name)' failed (az exited $($whatIf.ExitCode))."
                    "command : az $baseCommand --what-if"
                    "stderr  : $($whatIf.Errors)"
                    "stdout  : $($whatIf.Output)"
                ) -join [Environment]::NewLine)
        }
        return
    }

    $result = Invoke-AzCli $baseCommand -PassThru -NoAssert
    if ($result.ExitCode -ne 0) {
        throw (@(
                "Deployment '$($context.deployment.name)' failed (az exited $($result.ExitCode))."
                "command : az $baseCommand"
                "stderr  : $($result.Errors)"
                "stdout  : $($result.Output)"
            ) -join [Environment]::NewLine)
    }
    $deploymentOutput = $result.Output | ConvertFrom-Yaml
    Assert-True ($null -ne $deploymentOutput) -ErrorText 'Empty deployment output from az'

    if ($deploymentOutput.properties.provisioningState -ne 'Succeeded') {
        throw "Deployment '$($context.deployment.name)' did not succeed (state: $($deploymentOutput.properties.provisioningState))"
    }
    Write-Message "Deployment '$($context.deployment.name)' succeeded"

    $hookSplat['DeploymentOutput'] = $deploymentOutput
    if ($postDeployHook) {
        & $postDeployHook @hookSplat
    }

    Set-BicepTrackingTagSet -Environment $Environment -Template $Template -Slot $Slot | Out-Null
}
