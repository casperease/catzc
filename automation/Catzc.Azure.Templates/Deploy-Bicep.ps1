<#
---
catzc:
  derived:
    path: automation/Catzc.Azure.Templates/Deploy-Bicep.ps1
    kind: function
    module: Catzc.Azure.Templates
    visibility: public
    adrs:
      - ADR-AUTO-DRYRUN
      - ADR-AZ-DATAMOD
      - ADR-PWSH-DRYRUN#1
      - ADR-PWSH-ERROR#8
      - ADR-PWSH-PREPOST
---
#>

<#
.SYNOPSIS
    Deploys a bicep template to Azure (resolves context, runs hooks, calls az, sets tags).
.DESCRIPTION
    The session picks the slot: a customer subscription deploys the customer config, otherwise the root config.
.PARAMETER Environment
    Environment shortname.
.PARAMETER Template
    Template name.
.PARAMETER Slot
    Omitted selects the environment's base slot, the index-0 one.
.PARAMETER SubscriptionIdAssertIs
    Mandatory in a pipeline so a re-wired service connection cannot silently retarget a deploy; never a selector.
.PARAMETER ArtifactsFolder
    Required in a pipeline. Devbox callers can pass it with -DoNotRebuild to skip the local build.
.PARAMETER DoNotRebuild
    Devbox-only. Reuse the existing build instead of rebuilding.
.PARAMETER OverrideDoNotRunAndRun
    Devbox-only. Bypass the template's DoNotRun mode.
.PARAMETER DryRun
    The preview is Azure's server-side what-if, so it shows what Azure itself would change, not a local guess.
.EXAMPLE
    Deploy-Bicep dev sample            # deploys into the az session's subscription
.EXAMPLE
    Deploy-Bicep dev sample -DryRun
.EXAMPLE
    Deploy-Bicep nsub foundation -SubscriptionIdAssertIs a0e00000-de00-50b0-0000-000000000000
#>
function Deploy-Bicep {
    # -DryRun replaces ShouldProcess here, so the analyzer rule for state-changing functions is suppressed.
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

    # The assert guard is the pipeline's declared expectation, so a re-wired service connection cannot retarget it.
    # [comment:6](/docs/references/automation/catzc-azure-templates/Deploy-Bicep.ps1.md#comment6)
    if ((Test-IsRunningInPipeline) -and [string]::IsNullOrEmpty($SubscriptionIdAssertIs)) {
        throw "Deploy-Bicep requires -SubscriptionIdAssertIs in a pipeline — the pipeline must pin the subscription GUID its service connection is expected to target, for template '$Template' ($Environment)."
    }

    # Everything downstream reads the one resolved identity off the context, so config, artifacts and tags agree.
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

    # Absent hooks are no-ops, and the assets PrePost.psm1 starter is never loaded, only copied into templates.
    # [comment:8](/docs/references/automation/catzc-azure-templates/Deploy-Bicep.ps1.md#comment8)
    $preDeployHook = $null
    $postDeployHook = $null
    if ($null -ne $context.artifacts.prepost_module) {
        Write-Message "Importing per-template PrePost: $($context.artifacts.prepost_module)"
        $prepostModule = Import-Module (Resolve-RepoPath $context.artifacts.prepost_module) -Scope Local -Force -PassThru
        # The template's hooks run strict like every catzc module, whoever wrote them.
        # [comment:9](/docs/references/automation/catzc-azure-templates/Deploy-Bicep.ps1.md#comment9)
        . $prepostModule { Set-StrictMode -Version Latest }
        if ($prepostModule.ExportedCommands.ContainsKey('Invoke-BicepPreDeploy')) {
            $preDeployHook = $prepostModule.ExportedCommands['Invoke-BicepPreDeploy']
        }
        if ($prepostModule.ExportedCommands.ContainsKey('Invoke-BicepPostDeploy')) {
            $postDeployHook = $prepostModule.ExportedCommands['Invoke-BicepPostDeploy']
        }
    }

    # DryRun goes to PreDeploy as its own parameter: it is the side-effect kill switch, too special for the bag.
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

    # Repo-relative paths work because az runs from the repo root, so they never depend on the shell's directory.
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

    # -NoAssert lets a failed az call throw with the deployment name, command and stderr, not a bare exit code.
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
