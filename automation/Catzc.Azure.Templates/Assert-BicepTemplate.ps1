<#
---
catzc:
  derived:
    path: automation/Catzc.Azure.Templates/Assert-BicepTemplate.ps1
    kind: function
    module: Catzc.Azure.Templates
    visibility: public
    adrs:
      - ADR-AZ-DATAMOD#9
---
#>

<#
.SYNOPSIS
    Validates a bicep template (or all templates) against its options.yml and the azure config,
    collecting every problem and throwing one consolidated error. The explicit, author/CI-facing
    counterpart to the fail-fast checks Get-BicepTemplates runs at discovery.
.DESCRIPTION
    Unlike discovery, which stops at the first violation, this reports all of a template's problems in one throw.
    [comment:1](/docs/references/automation/catzc-azure-templates/Assert-BicepTemplate.ps1.md#comment1)
.PARAMETER Template
    Template name to validate. Omit to validate every template under infrastructure/templates/.
.PARAMETER Build
    Opt-in because it needs az and writes the template's build output folder; the default checks need neither.
    [comment:2](/docs/references/automation/catzc-azure-templates/Assert-BicepTemplate.ps1.md#comment2)
.EXAMPLE
    Assert-BicepTemplate my-template
.EXAMPLE
    Assert-BicepTemplate            # validate every template
.EXAMPLE
    Assert-BicepTemplate my-template -Build   # also compile with az
#>
function Assert-BicepTemplate {
    [CmdletBinding()]
    param(
        [Parameter(Position = 0)]
        [ArgumentCompleter({ Get-BicepTemplateNames })]
        [string] $Template,

        [switch] $Build
    )

    $root = Get-BicepTemplatesRoot
    Assert-PathExist $root -PathType Container

    $azure = Get-Config -Config azure

    if ($Template) {
        $targetFolder = Join-Path $root $Template
        Assert-True (Test-Path $targetFolder -PathType Container) -ErrorText "Template '$Template' not found under $root"
        $folders = @($targetFolder)
    }
    else {
        # Plain .NET enumeration avoids the roughly 20 ms per-call overhead of Get-ChildItem.
        # [comment:3](/docs/references/automation/catzc-azure-templates/Assert-BicepTemplate.ps1.md#comment3)
        $folders = @([System.IO.Directory]::EnumerateDirectories($root) | Sort-Object)
    }

    $errors = [System.Collections.Generic.List[string]]::new()
    $shortNames = @{}   # short_name -> template name (global-uniqueness check)

    foreach ($templateFolderPath in $folders) {
        $name = [System.IO.Path]::GetFileName($templateFolderPath)
        $main = Join-Path $templateFolderPath 'main.bicep'
        $configFolder = Join-Path $templateFolderPath 'configuration'

        if (-not (Test-Path $main -PathType Leaf)) {
            $errors.Add("[$name] missing main.bicep")
        }
        if (-not (Test-Path $configFolder -PathType Container)) {
            $errors.Add("[$name] missing configuration/ folder")
            continue
        }

        $options = $null
        try {
            $options = Read-BicepTemplateOptions $templateFolderPath
        }
        catch {
            $errors.Add("[$name] $($_.Exception.Message)")
            continue
        }

        $environmentKind = if ($options.Contains('environment_kind')) {
            "$($options.environment_kind)"
        }
        else {
            'standard'
        }

        # An explicit customer_deployment: true is only allowed when customers are enabled.
        # [comment:4](/docs/references/automation/catzc-azure-templates/Assert-BicepTemplate.ps1.md#comment4)
        $customerDeploymentOption = if ($options.Contains('customer_deployment')) {
            [bool]$options.customer_deployment
        }
        else {
            $null
        }
        if ($customerDeploymentOption -eq $true -and -not (Test-HaveCustomers)) {
            $errors.Add("[$name] sets customer_deployment: true but customer deployments are disabled — set have_customers in variants.yml (all, or a list of customer names)")
        }
        $customerDeployment = if ($null -ne $customerDeploymentOption) {
            $customerDeploymentOption
        }
        else {
            [bool](Test-HaveCustomers)
        }

        # A malformed override, or a folder that cannot derive a short_name, throws.
        # [comment:5](/docs/references/automation/catzc-azure-templates/Assert-BicepTemplate.ps1.md#comment5)
        $shortNameOverride = if ($options.Contains('short_name')) {
            "$($options.short_name)"
        }
        else {
            $null
        }
        $shortName = $null
        try {
            $shortName = [Catzc.Azure.Templates.BicepShortName]::Resolve($name, $shortNameOverride).value
        }
        catch {
            $errors.Add("[$name] $($_.Exception.Message)")
        }
        if ($null -ne $shortName) {
            if ($shortNames.ContainsKey($shortName)) {
                $errors.Add("[$name] short_name '$shortName' is not unique — also used by '$($shortNames[$shortName])'")
            }
            else {
                $shortNames[$shortName] = $name
            }
        }

        # Parameters main.bicep declares — a config may only set these.
        $declaredParameters = @()
        if (Test-Path $main -PathType Leaf) {
            $bicep = Get-Content $main -Raw
            $declaredParameters = @([regex]::Matches($bicep, '(?m)^\s*param\s+([A-Za-z_][A-Za-z0-9_]*)\b') | ForEach-Object { $_.Groups[1].Value })
        }

        # Gather configs: root files are shared-platform configs; a subfolder is always a customer key.
        $configEntries = [System.Collections.Generic.List[object]]::new()
        foreach ($file in @([System.IO.Directory]::EnumerateFiles($configFolder, '*.yml') | Sort-Object)) {
            $configEntries.Add([pscustomobject]@{ file = $file; customer = '' })
        }
        foreach ($customerDirectoryPath in ([System.IO.Directory]::EnumerateDirectories($configFolder) | Sort-Object)) {
            foreach ($file in @([System.IO.Directory]::EnumerateFiles($customerDirectoryPath, '*.yml') | Sort-Object)) {
                $configEntries.Add([pscustomobject]@{ file = $file; customer = [System.IO.Path]::GetFileName($customerDirectoryPath) })
            }
        }

        $nonDefault = @($configEntries | Where-Object { [IO.Path]::GetFileNameWithoutExtension($_.file) -ne 'default' })
        if ($nonDefault.Count -eq 0) {
            $errors.Add("[$name] has no config files under configuration/")
        }

        foreach ($entry in $nonDefault) {
            $configName = [IO.Path]::GetFileNameWithoutExtension($entry.file)
            $location = if ([string]::IsNullOrEmpty($entry.customer)) {
                "configuration/$configName.yml"
            }
            else {
                "configuration/$($entry.customer)/$configName.yml"
            }

            $resolved = $null
            try {
                $resolved = Resolve-BicepConfigName $configName
            }
            catch {
                $errors.Add("[$name] $location — $($_.Exception.Message)")
            }
            if ($null -ne $resolved) {
                foreach ($violation in (Get-BicepSubscriptionConfigViolations -Customer $entry.customer -Environment $resolved.environment -AzureConfig $azure -Location $location)) {
                    $errors.Add("[$name] $violation")
                }
                foreach ($violation in (Get-BicepConfigClassViolations -Environment $resolved.environment -EnvironmentKind $environmentKind -AzureConfig $azure -Location $location)) {
                    $errors.Add("[$name] $violation")
                }
                foreach ($violation in (Get-BicepCustomerClassViolations -Customer $entry.customer -CustomerDeployment $customerDeployment -Location $location)) {
                    $errors.Add("[$name] $violation")
                }
            }

            # Parameter alignment.
            if ($declaredParameters.Count -gt 0) {
                $configuration = $null
                try {
                    $configuration = Get-Content $entry.file -Raw | ConvertFrom-Yaml -Ordered
                }
                catch {
                    $errors.Add("[$name] $location — invalid YAML: $($_.Exception.Message)")
                }
                if ($null -ne $configuration -and $configuration.Contains('ParametersFile') -and $configuration.ParametersFile -and $configuration.ParametersFile.Contains('parameters') -and $configuration.ParametersFile.parameters) {
                    foreach ($parameterName in @($configuration.ParametersFile.parameters.Keys)) {
                        if ($parameterName -notin $declaredParameters) {
                            $errors.Add("[$name] $location sets parameter '$parameterName', which main.bicep does not declare")
                        }
                    }
                }
            }
        }

        if ($Build -and (Test-Path $main -PathType Leaf)) {
            if (-not (Get-Command az -ErrorAction Ignore)) {
                $errors.Add("[$name] -Build requested but 'az' is not installed")
            }
            else {
                # Both render and compile run, so the parameters files can be checked against the compiled model.
                # [ADR-AZ-DATAMOD#9](/docs/adr/azure/azure-data-model.md#rule-adr-az-datamod9)
                # [comment:6](/docs/references/automation/catzc-azure-templates/Assert-BicepTemplate.ps1.md#comment6)
                $built = $false
                try {
                    Build-Bicep $name | Out-Null
                    $built = $true
                }
                catch {
                    $errors.Add("[$name] Build-Bicep failed: $($_.Exception.Message)")
                }
                if ($built) {
                    foreach ($violation in @(Get-BicepParameterViolations $name)) {
                        $errors.Add("[$name] $violation")
                    }
                }
            }
        }
    }

    if ($errors.Count -gt 0) {
        throw "Template validation failed:`n$($errors -join "`n")"
    }
}
