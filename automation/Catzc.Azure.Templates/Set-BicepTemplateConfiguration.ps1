<#
---
catzc:
  derived:
    path: automation/Catzc.Azure.Templates/Set-BicepTemplateConfiguration.ps1
    kind: function
    module: Catzc.Azure.Templates
    visibility: public
    adrs:
      - ADR-AUTO-DRYRUN
      - ADR-AZ-DATAMOD
      - ADR-FLOW-CD-TYPE
      - ADR-PWSH-DRYRUN#1
---
#>

<#
.SYNOPSIS
    Writes (or merges) a template's per-slot ParametersFile into its config file. The write half of
    the INPUT pipeline: it turns user input into a version-controlled change, never a runtime cloud
    mutation.
.DESCRIPTION
    Idempotent: existing parameters and keys are preserved, a missing config is created, and nothing is deployed.
    [ADR-AZ-DATAMOD](/docs/adr/azure/azure-data-model.md),
    [ADR-FLOW-CD-TYPE](/docs/adr/flow/pipeline-types.md)
    [comment:1](/docs/references/automation/catzc-azure-templates/Set-BicepTemplateConfiguration.ps1.md#comment1)
.PARAMETER Template
    Template name (folder under infrastructure/templates/).
.PARAMETER Environment
    The template may have no config for it yet; creating that config is how a slot is added.
    [comment:2](/docs/references/automation/catzc-azure-templates/Set-BicepTemplateConfiguration.ps1.md#comment2)
.PARAMETER Parameters
    Hashtable of ARM parameter name -> value. Each becomes `parameters.<name>.value = <value>`.
.PARAMETER Slot
    Optional special-slot discriminator (1-3 lowercase alphanumeric). Omitted ⇒ the base / index-0 slot.
.PARAMETER Customer
    Omitted writes the configuration-root config; the coordinate must resolve to exactly one subscription.
    [comment:3](/docs/references/automation/catzc-azure-templates/Set-BicepTemplateConfiguration.ps1.md#comment3)
.PARAMETER DryRun
    Nothing is written, so the preview shows exactly the path and content a real run would use.
    [ADR-AUTO-DRYRUN](/docs/adr/automation/dry-run.md)
    [comment:4](/docs/references/automation/catzc-azure-templates/Set-BicepTemplateConfiguration.ps1.md#comment4)
.EXAMPLE
    Set-BicepTemplateConfiguration discovery dev -Parameters @{ sqlAdminLogin = 'admin' }
.EXAMPLE
    Set-BicepTemplateConfiguration discovery dev -Customer apex -Parameters @{ sqlAdminLogin = 'admin' } -DryRun
#>
function Set-BicepTemplateConfiguration {
    # -DryRun replaces ShouldProcess here, so the analyzer rule for state-changing functions is suppressed.
    # [ADR-AUTO-DRYRUN](/docs/adr/automation/dry-run.md)
    # [comment:5](/docs/references/automation/catzc-azure-templates/Set-BicepTemplateConfiguration.ps1.md#comment5)
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessForStateChangingFunctions', '', Justification = 'Uses -DryRun instead of ShouldProcess — see ADR-PWSH-DRYRUN#1')]
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

    # The same rule discovery enforces, so a config written here never fails the next discovery.
    # [comment:6](/docs/references/automation/catzc-azure-templates/Set-BicepTemplateConfiguration.ps1.md#comment6)
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
