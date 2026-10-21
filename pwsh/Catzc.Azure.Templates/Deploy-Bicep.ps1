<#
---
catzc:
  immutable:
    with_body_sha: "19936dc38441"
  edges:
    test: pwsh/Catzc.Azure.Templates/tests/Deploy-Bicep.Tests.ps1
    docs: "[Deploy-Bicep.ps1.md](../../docs/references/pwsh/catzc-azure-templates/Deploy-Bicep.ps1.md)"
    cites:
      - ADR-AUTO-DRYRUN
      - ADR-AZ-DATAMOD
      - ADR-PWSH-DRYRUN-SUPPRESSSHOULDPROCESS
      - ADR-PWSH-ERROR-STRICTCLEAN
      - ADR-PWSH-PREPOST
---
#>

function Deploy-Bicep {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessForStateChangingFunctions', '', Justification = 'Uses -DryRun instead of ShouldProcess — see ADR-PWSH-DRYRUN-SUPPRESSSHOULDPROCESS')]
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

    if ((Test-IsRunningInPipeline) -and [string]::IsNullOrEmpty($SubscriptionIdAssertIs)) {
        throw "Deploy-Bicep requires -SubscriptionIdAssertIs in a pipeline — the pipeline must pin the subscription GUID its service connection is expected to target, for template '$Template' ($Environment)."
    }

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

    $preDeployHook = $null
    $postDeployHook = $null
    if ($null -ne $context.artifacts.prepost_module) {
        Write-Message "Importing per-template PrePost: $($context.artifacts.prepost_module)"
        $prepostModule = Import-Module (Resolve-RepoPath $context.artifacts.prepost_module) -Scope Local -Force -PassThru
        . $prepostModule { Set-StrictMode -Version Latest }
        if ($prepostModule.ExportedCommands.ContainsKey('Invoke-BicepPreDeploy')) {
            $preDeployHook = $prepostModule.ExportedCommands['Invoke-BicepPreDeploy']
        }
        if ($prepostModule.ExportedCommands.ContainsKey('Invoke-BicepPostDeploy')) {
            $postDeployHook = $prepostModule.ExportedCommands['Invoke-BicepPostDeploy']
        }
    }

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

    if ($preDeployHook) {
        & $preDeployHook @hookSplat -DryRun:$DryRun
    }

    if ($context.deployment.target -eq 'ResourceGroup') {
        Deploy-AzureResourceGroup -SubscriptionId $context.environment.subscription.id -Region $context.environment.region -ResourceGroup $context.deployment.resource_group -DryRun:$DryRun | Out-Null
    }

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
