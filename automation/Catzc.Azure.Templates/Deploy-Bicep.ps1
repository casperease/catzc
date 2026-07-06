<#
.SYNOPSIS
    Deploys a bicep template to Azure (resolves context, runs hooks, calls az, sets tags).
.DESCRIPTION
    Flow:
    1. Assert-AzCliIsConnected             (correct tenant + subscription).
    2. Get-BicepDeploymentContext           (devbox auto-runs Build-Bicep; pipeline uses ArtifactsFolder).
       Returns $null if mode is DoNotRun without -OverrideDoNotRunAndRun → skip.
    3. Import the template's own PrePost.psm1 from artifacts (if it ships one); resolve the hooks it exports.
    4. Run the template's Invoke-BicepPreDeploy hook if it exports one (else no-op).
    5. ResourceGroup target: Deploy-AzureResourceGroup (idempotent).
    6. az deployment {group|sub} create — passes ABSOLUTE --template-file / --parameters paths so the
       call never depends on the process working directory. -DryRun appends `--what-if` and stops here.
    7. Assert provisioningState = Succeeded.
    8. Run the template's Invoke-BicepPostDeploy hook if it exports one (gets the parsed output).
    9. Set-BicepTrackingTagSet.

    Pass -DryRun to preview: it runs `az deployment ... create --what-if` (Azure's server-side preview)
    and skips the real deploy, the post-deploy hook, and tag-setting. See
    docs/adr/automation/prefer-dryrun-over-shouldprocess.md.
.PARAMETER Environment
    Environment shortname.
.PARAMETER Template
    Template name.
.PARAMETER Slot
    Optional special-slot discriminator (1-3 lowercase alphanumeric chars, `001`). Selects the slot to
    deploy; omitted -> the env's base / index-0 slot.
.PARAMETER Subscription
    Subscription (the config folder) to deploy. On a devbox it is resolved from (env, slot) when omitted
    (required only when more than one subscription serves that env+slot). In a pipeline it is
    MANDATORY — inference is devbox-only, so a later template-config addition can never silently retarget
    or break a pipeline's deploy.
.PARAMETER ArtifactsFolder
    Required in a pipeline. Devbox callers can pass it with -DoNotRebuild to skip the local build.
.PARAMETER DoNotRebuild
    Devbox-only. Reuse the existing build instead of rebuilding.
.PARAMETER OverrideDoNotRunAndRun
    Devbox-only. Bypass the template's DoNotRun mode.
.PARAMETER DryRun
    Preview only — runs the Azure `--what-if` deployment and skips the real deploy, post-deploy hook,
    and tag-setting.
.EXAMPLE
    Deploy-Bicep dev sample
.EXAMPLE
    Deploy-Bicep dev sample -DryRun
.EXAMPLE
    Deploy-Bicep dev sample-customer -Subscription apex_nonprod   # into apex's subscription
#>
function Deploy-Bicep {
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

        [string] $ArtifactsFolder,
        [switch] $DoNotRebuild,
        [switch] $OverrideDoNotRunAndRun,
        [switch] $DryRun
    )

    # In a pipeline the subscription MUST be explicit — inference is devbox-only. Otherwise adding a
    # template config (which can make a given (env, slot) ambiguous across subscriptions) would silently
    # retarget, or break, an existing pipeline's deploy. Fail fast at the call site instead. See
    # docs/adr/azure/data-model.md.
    if ((Test-IsRunningInPipeline) -and [string]::IsNullOrEmpty($Subscription)) {
        throw "Deploy-Bicep requires an explicit -Subscription in a pipeline (subscription inference is devbox-only). Pass -Subscription <name> for template '$Template' ($Environment)."
    }

    # The deploy targets one subscription (the config folder). Resolve it once and thread it through, so
    # the connection guard checks THAT subscription and context/config/tags all agree.
    $subscription = Resolve-BicepDeploymentSubscription -Template $Template -Environment $Environment -Slot $Slot -Subscription $Subscription
    Assert-AzCliIsConnected -Subscription $subscription

    $context = Get-BicepDeploymentContext `
        -Environment $Environment `
        -Template $Template `
        -Slot $Slot `
        -Subscription $subscription `
        -ArtifactsFolder $ArtifactsFolder `
        -DoNotRebuild:$DoNotRebuild `
        -OverrideDoNotRunAndRun:$OverrideDoNotRunAndRun

    if ($null -eq $context) {
        Write-Message "Skipping deployment for '$Template' ($Environment) — DoNotRun"
        return
    }

    Write-Object $context -Name 'deployment context'

    $templateDescriptor = Get-BicepTemplate $Template
    $configurationDescriptor = Get-BicepTemplateConfiguration $Template $Environment -Slot $Slot -Subscription $subscription

    # A template MAY ship infrastructure/templates/<name>/PrePost.psm1 exporting Invoke-BicepPreDeploy /
    # Invoke-BicepPostDeploy. Resolve whichever it exports; absent hooks are no-ops. The
    # assets/PrePost.psm1 starter is never loaded — it exists only to be copied into a template.
    $preDeployHook = $null
    $postDeployHook = $null
    if ($null -ne $context.artifacts.prepost_module) {
        Write-Message "Importing per-template PrePost: $($context.artifacts.prepost_module)"
        $prepostModule = Import-Module (Resolve-RepoPath $context.artifacts.prepost_module) -Scope Local -Force -PassThru
        if ($prepostModule.ExportedCommands.ContainsKey('Invoke-BicepPreDeploy')) {
            $preDeployHook = $prepostModule.ExportedCommands['Invoke-BicepPreDeploy']
        }
        if ($prepostModule.ExportedCommands.ContainsKey('Invoke-BicepPostDeploy')) {
            $postDeployHook = $prepostModule.ExportedCommands['Invoke-BicepPostDeploy']
        }
    }

    # The deploy invocation — the arguments this deploy is acting on (incl. Mode). DryRun is passed
    # as its own first-class parameter to PreDeploy (it's the side-effect kill switch — too special
    # to hide in a bag). Computed descriptor objects stay separate.
    # See docs/adr/automation/powershell/prepost-extension-modules.md.
    $customer = if ($null -ne $context.environment.subscription.customer) {
        $context.environment.subscription.customer
    }
    else {
        ''
    }
    $deployInvocation = [ordered]@{
        Template     = $Template
        Environment  = $Environment
        Slot         = $Slot
        Subscription = $subscription
        Customer     = $customer
        Mode         = $context.deployment.mode
    }
    $hookSplat = [ordered]@{
        DeployInvocation        = $deployInvocation
        TemplateDescriptor      = $templateDescriptor
        ConfigurationDescriptor = $configurationDescriptor
        EnvironmentDescriptor   = $context.environment
    }

    # PreDeploy runs before the --what-if branch, so it gets -DryRun and must honor it. PostDeploy
    # only runs after a real deploy, so it never receives DryRun.
    if ($preDeployHook) {
        & $preDeployHook @hookSplat -DryRun:$DryRun
    }

    if ($context.deployment.target -eq 'ResourceGroup') {
        Deploy-AzureResourceGroup -SubscriptionId $context.environment.subscription.id -Region $context.environment.region -ResourceGroup $context.deployment.resource_group -DryRun:$DryRun | Out-Null
    }

    # The artifact paths are repo-relative where possible (absolute for external pipeline artifacts).
    # az runs from the repo root (Invoke-Executable's WorkingDirectory), so a repo-relative path
    # resolves there and an absolute one is honored as-is — either way independent of the shell's $PWD.
    # Quoted in case a path contains spaces.
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

    # -NoAssert on the az deployment calls: a non-zero exit throws WITH context (the deployment name,
    # the exact az command, az's stderr/stdout) from here, instead of the generic exit-code assertion
    # buried in Invoke-Executable. az's stderr is where the cause lives — a policy denial, an invalid
    # template, a quota/auth error — so it must travel in the thrown error, not just the console stream.
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

    Set-BicepTrackingTagSet -Environment $Environment -Template $Template -Slot $Slot -Subscription $subscription | Out-Null
}
