<#
---
catzc:
  derived:
    path: automation/Catzc.Azure.Templates/Get-BicepTemplates.ps1
    kind: function
    module: Catzc.Azure.Templates
    visibility: public
    adrs:
      - ADR-AUTO-CACHE
      - ADR-AZ-CUSTOMER
      - ADR-AZ-DATAMOD
      - ADR-AZ-NAMING#2
      - ADR-PWSH-CACHE#4
---
#>

# cspell:ignore etlco
<#
.SYNOPSIS
    Discovers all bicep templates under $(Get-RepositoryRoot)/infrastructure/templates.
.DESCRIPTION
    Reusable modules in infrastructure/modules/ are not discovered; one config file maps to one resource group.
    [comment:1](/docs/references/automation/catzc-azure-templates/Get-BicepTemplates.ps1.md#comment1)
.EXAMPLE
    Get-BicepTemplates | Format-Table name, deployment_target, environments
#>
function Get-BicepTemplates {
    param()

    $infrastructureRoot = Get-BicepTemplatesRoot
    $outputRoot = Get-BicepTemplatesOutputRoot

    # Keyed on the discovery and output roots, so tests can redirect either without touching the real entry.
    # [comment:2](/docs/references/automation/catzc-azure-templates/Get-BicepTemplates.ps1.md#comment2)
    if ($null -eq $ExecutionContext.SessionState.PSVariable.GetValue('script:bicepTemplatesCache')) {
        # GetValue probes the entry because a plain script: read would throw under strict mode before first use.
        # [comment:3](/docs/references/automation/catzc-azure-templates/Get-BicepTemplates.ps1.md#comment3)
        $script:bicepTemplatesCache = @{}
    }
    $cacheKey = "$infrastructureRoot|$outputRoot"
    if ($script:bicepTemplatesCache.ContainsKey($cacheKey)) {
        return , $script:bicepTemplatesCache[$cacheKey]
    }

    if (-not (Test-Path $infrastructureRoot -PathType Container)) {
        return @()
    }

    # The customer-key and single-subscription checks run at discovery, shared with Assert-BicepTemplate.
    # [comment:4](/docs/references/automation/catzc-azure-templates/Get-BicepTemplates.ps1.md#comment4)
    $azure = Get-Config -Config azure

    $templates = [System.Collections.Generic.List[object]]::new()
    # Get-ChildItem costs about 20 ms of provider overhead per call, the dominant share of a cold discovery.
    # [comment:5](/docs/references/automation/catzc-azure-templates/Get-BicepTemplates.ps1.md#comment5)
    foreach ($folderPath in ([System.IO.Directory]::EnumerateDirectories($infrastructureRoot) | Sort-Object)) {
        $name = [System.IO.Path]::GetFileName($folderPath)

        $main = Join-Path $folderPath 'main.bicep'
        Assert-PathExist $main -PathType Leaf

        $configurationFolder = Join-Path $folderPath 'configuration'
        Assert-PathExist $configurationFolder -PathType Container

        $options = Read-BicepTemplateOptions $folderPath
        # Every config below must match this bit; the slot is per-config, not a template bit.
        # [comment:6](/docs/references/automation/catzc-azure-templates/Get-BicepTemplates.ps1.md#comment6)
        $environmentKind = if ($options.Contains('environment_kind')) {
            "$($options.environment_kind)"
        }
        else {
            'standard'
        }

        # An explicit customer_deployment: true is only allowed when customers are enabled, the repo-level guard.
        # [comment:7](/docs/references/automation/catzc-azure-templates/Get-BicepTemplates.ps1.md#comment7)
        $customerDeploymentOption = if ($options.Contains('customer_deployment')) {
            [bool]$options.customer_deployment
        }
        else {
            $null
        }
        if ($customerDeploymentOption -eq $true -and -not (Test-HaveCustomers)) {
            throw "Template '$name' sets customer_deployment: true but customer deployments are disabled — set have_customers in variants.yml (all, or a list of customer names)."
        }
        $customerDeployment = if ($null -ne $customerDeploymentOption) {
            $customerDeploymentOption
        }
        else {
            [bool](Test-HaveCustomers)
        }

        # A malformed override, or a folder that cannot derive a short_name, throws here naming the template.
        # [comment:8](/docs/references/automation/catzc-azure-templates/Get-BicepTemplates.ps1.md#comment8)
        $shortNameOverride = if ($options.Contains('short_name')) {
            "$($options.short_name)"
        }
        else {
            $null
        }
        $shortName = [Catzc.Azure.Templates.BicepShortName]::Resolve($name, $shortNameOverride)

        # Root files come first, then the customer subfolders, both sorted, so output stays deterministic.
        # [comment:9](/docs/references/automation/catzc-azure-templates/Get-BicepTemplates.ps1.md#comment9)
        $configEntries = [System.Collections.Generic.List[object]]::new()
        foreach ($file in @([System.IO.Directory]::EnumerateFiles($configurationFolder, '*.yml') | Sort-Object)) {
            $configEntries.Add([pscustomobject]@{ file = $file; customer = '' })
        }
        foreach ($customerDirectoryPath in ([System.IO.Directory]::EnumerateDirectories($configurationFolder) | Sort-Object)) {
            $customer = [System.IO.Path]::GetFileName($customerDirectoryPath)
            foreach ($file in @([System.IO.Directory]::EnumerateFiles($customerDirectoryPath, '*.yml') | Sort-Object)) {
                $configEntries.Add([pscustomobject]@{ file = $file; customer = $customer })
            }
        }

        # default.yml is a reserved skip; each other config maps to one slot, one subscription and one resource group.
        # [comment:10](/docs/references/automation/catzc-azure-templates/Get-BicepTemplates.ps1.md#comment10)
        $slots = [System.Collections.Generic.List[object]]::new()
        $configurationFiles = [System.Collections.Generic.List[string]]::new()
        foreach ($entry in $configEntries) {
            $configName = [IO.Path]::GetFileNameWithoutExtension($entry.file)
            if ($configName -eq 'default') {
                continue
            }
            $configurationFiles.Add($entry.file)
            $location = if ([string]::IsNullOrEmpty($entry.customer)) {
                "configuration/$configName.yml"
            }
            else {
                "configuration/$($entry.customer)/$configName.yml"
            }
            try {
                $resolved = Resolve-BicepConfigName $configName
            }
            catch {
                throw "Template '$name' has $location — $($_.Exception.Message)"
            }
            $subscriptionViolations = Get-BicepSubscriptionConfigViolations -Customer $entry.customer -Environment $resolved.environment -AzureConfig $azure -Location $location
            if ($subscriptionViolations) {
                throw "Template '$name' has an invalid config: $($subscriptionViolations -join '; ')."
            }
            $classViolations = Get-BicepConfigClassViolations -Environment $resolved.environment -EnvironmentKind $environmentKind -AzureConfig $azure -Location $location
            if ($classViolations) {
                throw "Template '$name' has an invalid config: $($classViolations -join '; ')."
            }
            $customerViolations = Get-BicepCustomerClassViolations -Customer $entry.customer -CustomerDeployment $customerDeployment -Location $location
            if ($customerViolations) {
                throw "Template '$name' has an invalid config: $($customerViolations -join '; ')."
            }

            $subscription = Get-BicepConfigSubscriptionCandidates -Customer $entry.customer -Environment $resolved.environment -AzureConfig $azure |
                Select-Object -First 1
            $slots.Add([Catzc.Azure.Templates.BicepSlot]::new($configName, $resolved.environment, $resolved.slot, $subscription, $entry.customer))
        }
        $environments = @($slots | ForEach-Object { $_.environment } | Select-Object -Unique)
        $subscriptions = @($slots | ForEach-Object { $_.subscription } | Select-Object -Unique)
        $customers = @($slots | Where-Object { $_.customer } | ForEach-Object { $_.customer } | Select-Object -Unique)

        $bicepFiles = @([System.IO.Directory]::EnumerateFiles($folderPath, '*.bicep') | Sort-Object)

        $template = [ordered]@{
            name                 = $name
            folder               = $folderPath
            main                 = $main
            bicep_files          = $bicepFiles
            configuration_folder = $configurationFolder
            configuration_files  = $configurationFiles.ToArray()
            environments         = $environments
            subscriptions        = $subscriptions
            customers            = $customers
            slots                = $slots.ToArray()
            short_name           = $shortName.value
            output_folder        = Join-Path $outputRoot "template/$name"
            deployment_mode      = 'Incremental'
            deployment_target    = 'ResourceGroup'
            environment_kind     = $environmentKind
            customer_deployment  = $customerDeployment
        }

        # short_name, environment_kind and customer_deployment are applied above, so they are excluded here.
        # [comment:11](/docs/references/automation/catzc-azure-templates/Get-BicepTemplates.ps1.md#comment11)
        foreach ($key in @($options.Keys)) {
            if ($key -in 'short_name', 'environment_kind', 'customer_deployment') {
                continue
            }
            $template[$key] = $options[$key]
        }

        $prepostModule = Join-Path $folderPath 'PrePost.psm1'
        if (Test-Path $prepostModule -PathType Leaf) {
            $template['prepost_module'] = $prepostModule
        }

        $resourcesFolder = Join-Path $folderPath 'resources'
        if (Test-Path $resourcesFolder -PathType Container) {
            $template['resources'] = @([System.IO.Directory]::EnumerateFiles($resourcesFolder) | Sort-Object)
        }

        $templates.Add([Catzc.Azure.Templates.BicepTemplate]::new($template))
    }

    # short_name is the globally-unique Azure id segment — no two templates may share one.
    $duplicateShortNames = $templates | ForEach-Object { $_.short_name } | Group-Object | Where-Object Count -GT 1
    foreach ($duplicate in $duplicateShortNames) {
        throw "Duplicate short_name '$($duplicate.Name)' across templates: $(@($templates | Where-Object { $_.short_name -eq $duplicate.Name } | ForEach-Object { $_.name }) -join ', ')"
    }

    $script:bicepTemplatesCache[$cacheKey] = $templates.ToArray()
    , $script:bicepTemplatesCache[$cacheKey]
}
