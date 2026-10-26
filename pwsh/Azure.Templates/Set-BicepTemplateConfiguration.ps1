<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-azure-templates/Set-BicepTemplateConfiguration.ps1.md"
  header: "generated"
---
#>

function Set-BicepTemplateConfiguration {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessForStateChangingFunctions', '',
        Justification = 'Uses -DryRun instead of ShouldProcess — see ADR-PWSH-DRYRUN-SUPPRESSSHOULDPROCESS')]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '',
        Justification = 'ArgumentCompleter scriptblocks require PowerShell''s fixed 5-parameter completer signature; only $fakeBoundParameters is used, but the other four are mandatory and cannot be removed')]
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
    $bicepParamFile = Join-Path $folder "$configName.bicepparam"
    if ([System.IO.File]::Exists($bicepParamFile)) {
        throw "Template '$Template' slot '$configName' is a bicepparam slot ($bicepParamFile): it is edited by hand, not by Set-BicepTemplateConfiguration (ADR-AZ-DATAMOD-BICEPPARAMSLOT)."
    }

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

    # One config file is one resource group; the head carries the one warning.
    $relative = ConvertTo-RepoRelativePath $configFile
    $yaml = (ConvertTo-Yaml $config) -replace "`r`n", "`n"
    $content = Format-GeneratedFileHead -Text $yaml -Path $relative

    if ($DryRun) {
        Write-Message "[DryRun] would write $configFile"
        return [PSCustomObject]@{ Path = $configFile; Content = $content; Written = $false }
    }

    New-Item -ItemType Directory -Path $folder -Force | Out-Null
    [IO.File]::WriteAllText($configFile, $content)
    Write-Message "Wrote $configFile ($($Parameters.Count) parameter(s))"

    [PSCustomObject]@{ Path = $configFile; Content = $content; Written = $true }
}
