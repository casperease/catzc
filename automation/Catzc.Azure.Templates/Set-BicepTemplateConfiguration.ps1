<#
.SYNOPSIS
    Writes (or merges) a template's per-slot ParametersFile into its config file. The write half of
    the INPUT pipeline: it turns user input into a version-controlled change, never a runtime cloud
    mutation. See docs/adr/pipelines/pipeline-types.md and docs/adr/azure/data-model.md.
.DESCRIPTION
    Resolves the config file for a (template[, customer], environment[, slot]) coordinate —
    `infrastructure/templates/<template>/configuration/[<customer>/]<env>[-<slot>].yml` — and sets the
    given parameters under `ParametersFile.parameters`. Each entry is written ARM-style as
    `{ <name>: { value: <value> } }`.

    Idempotent (Set-): an existing config is loaded and the named parameters are overlaid (other
    parameters and keys are preserved); a missing config is created (the customer subdir too).
    Running it twice with the same input leaves the same file. The config file need not exist yet — that
    is how a new slot / resource group is introduced (the next discovery picks it up).

    This function does NOT deploy, render, or call Azure. It only edits a file. Deployment of the change
    is the CD pipeline's job, against version control.
.PARAMETER Template
    Template name (folder under infrastructure/templates/).
.PARAMETER Environment
    Environment name — must be a defined environment in azure.yml (it may be one the template does not
    yet have a config for; that is the point of creating a new slot).
.PARAMETER Parameters
    Hashtable of ARM parameter name -> value. Each becomes `parameters.<name>.value = <value>`.
.PARAMETER Slot
    Optional special-slot discriminator (1-3 lowercase alphanumeric). Omitted ⇒ the base / index-0 slot.
.PARAMETER Customer
    Optional customer key (customer.yml) — the config subfolder to write under
    (`configuration/<customer>/`). Omitted writes the configuration-root (shared-platform) config. The
    coordinate must resolve to exactly one subscription (the same rule discovery enforces).
.PARAMETER DryRun
    Preview only — returns the planned path and content without writing. See
    docs/adr/automation/prefer-dryrun-over-shouldprocess.md.
.EXAMPLE
    Set-BicepTemplateConfiguration discovery dev -Parameters @{ sqlAdminLogin = 'admin' }
.EXAMPLE
    Set-BicepTemplateConfiguration discovery dev -Customer apex -Parameters @{ sqlAdminLogin = 'admin' } -DryRun
#>
function Set-BicepTemplateConfiguration {
    # State-changing function deliberately uses -DryRun, not ShouldProcess — see
    # docs/adr/automation/prefer-dryrun-over-shouldprocess.md.
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessForStateChangingFunctions', '', Justification = 'Uses -DryRun instead of ShouldProcess — see docs/adr/automation/prefer-dryrun-over-shouldprocess.md#rule-adr-dryrun5')]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'ArgumentCompleter scriptblocks require PowerShell''s fixed 5-parameter completer signature; only $fakeBoundParameters is used, but the other four are mandatory and cannot be removed')]
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        [ArgumentCompleter({ Get-BicepTemplateNames })]
        [ValidateScript({ $_ -in (Get-BicepTemplateNames) })]
        [string] $Template,

        [Parameter(Mandatory, Position = 1)]
        [ArgumentCompleter({ (Get-Config -Config azure).environments.Keys })]
        [string] $Environment,

        [Parameter(Mandatory)]
        [hashtable] $Parameters,

        [Parameter(Position = 2)]
        [string] $Slot,

        [ArgumentCompleter({
                param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)
                Get-BicepTemplateCustomers -Template $fakeBoundParameters['Template']
            })]
        [string] $Customer,

        [switch] $DryRun
    )

    Assert-True ($Parameters.Count -gt 0) -ErrorText 'Parameters cannot be empty — pass at least one name/value pair.'

    # Environment must be defined in azure.yml. The slot is validated by shape.
    $azure = Get-Config -Config azure
    $knownEnvironments = @($azure.environments.Keys)
    Assert-True ($Environment -in $knownEnvironments) -ErrorText "Environment '$Environment' is not defined in azure.yml (valid: $($knownEnvironments -join ', '))"

    if (-not [string]::IsNullOrEmpty($Slot) -and $Slot -notmatch '(?-i)^[a-z0-9]{1,3}$') {
        throw "Invalid -Slot '$Slot' — must be 1-3 lowercase alphanumeric chars (e.g. 001)."
    }

    # The coordinate must conform to the conventional tree (the same cross-layer rule discovery
    # enforces): the customer subfolder is a defined customer key, and the (customer?, env) coordinate
    # resolves to exactly one subscription.
    $loc = if ([string]::IsNullOrEmpty($Customer)) {
        "configuration/$Environment.yml"
    }
    else {
        "configuration/$Customer/$Environment.yml"
    }
    $subViolations = @(Get-BicepSubscriptionConfigViolations -Customer $Customer -Environment $Environment -AzureConfig $azure -Location $loc)
    Assert-True ($subViolations.Count -eq 0) -ErrorText ($subViolations -join '; ')

    # Resolve the config file path: <configuration_folder>/[<customer>/]<env>[-<slot>].yml.
    $templateDescriptor = Get-BicepTemplate $Template
    $configName = Get-BicepConfigName $Environment $Slot
    $folder = if ([string]::IsNullOrEmpty($Customer)) {
        $templateDescriptor.configuration_folder
    }
    else {
        Join-Path $templateDescriptor.configuration_folder $Customer
    }
    $configFile = Join-Path $folder "$configName.yml"

    # Load the existing config (preserve unrelated keys) or start a fresh ordered structure.
    $config = if (Test-Path $configFile -PathType Leaf) {
        Get-Content $configFile -Raw | ConvertFrom-Yaml -Ordered
    }
    else {
        [ordered]@{}
    }
    if (-not $config.Contains('ParametersFile')) {
        $config['ParametersFile'] = [ordered]@{}
    }
    if (-not $config['ParametersFile'].Contains('parameters')) {
        $config['ParametersFile']['parameters'] = [ordered]@{}
    }

    # Overlay each provided parameter as the ARM `{ value: ... }` shape, preserving any others.
    foreach ($name in $Parameters.Keys) {
        $config['ParametersFile']['parameters'][$name] = [ordered]@{ value = $Parameters[$name] }
    }

    $banner = "# Generated by Set-BicepTemplateConfiguration (INPUT pipeline). One config file ⟷ one RG.`n" +
    "# Edits here are a version-controlled change; deployment is the CD pipeline's job.`n"
    $yaml = ConvertTo-Yaml $config
    $content = ($banner + $yaml) -replace "`r`n", "`n"

    if ($DryRun) {
        Write-Message "[DryRun] would write $configFile"
        return [PSCustomObject]@{ Path = $configFile; Content = $content; Written = $false }
    }

    New-Item -ItemType Directory -Path $folder -Force | Out-Null
    [IO.File]::WriteAllText($configFile, $content)
    Write-Message "Wrote $configFile ($($Parameters.Count) parameter(s))"

    [PSCustomObject]@{ Path = $configFile; Content = $content; Written = $true }
}
