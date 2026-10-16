<#
---
catzc:
  derived:
    path: automation/Catzc.Azure.Templates/Get-BicepTemplates.ps1
    kind: automation-function
    language: powershell
    track: automation
    module: Catzc.Azure.Templates
    visibility: public
    relatives:
      page: docs/references/automation/catzc-azure-templates/Get-BicepTemplates.ps1.md
      test: automation/Catzc.Azure.Templates/tests/Get-BicepTemplates.Tests.ps1
    adrs:
      - ADR-AUTO-CACHE
      - ADR-AZ-CUSTOMER
      - ADR-AZ-DATAMOD
      - ADR-AZ-NAMING#2
      - ADR-PWSH-CACHE#4
  config:
    synopsis: Discovers all bicep templates under $(Get-RepositoryRoot)/infrastructure/templates.
    description: |-
      Scans `infrastructure/templates/` at depth 1 for template folders (reusable bicep modules live
      in the sibling `infrastructure/modules/` and are NOT discovered here). Each folder must contain
      a `main.bicep` and a `configuration/` subfolder. A config lives at the configuration ROOT —
      `configuration/<env>[-<slot>].yml`, a shared-platform deployment — or under a customer subfolder,
      `configuration/<customer>/<env>[-<slot>].yml`, where the folder is always a customer KEY from
      customer.yml. One config file ⟷ one resource group
      ([ADR-AZ-DATAMOD](/docs/adr/azure/azure-data-model.md)). The filename
      resolves (Resolve-BicepConfigName) to its environment + optional slot: `dev.yml` (base slot of env
      `dev`), `dev-001.yml` (slot `001`). The SUBSCRIPTION is resolved per config
      (Get-BicepConfigSubscriptionCandidates): a root config's env must be served by exactly one
      non-customer subscription; a customer config's env by exactly one of that customer's subscriptions.
      Validated at discovery: the subfolder is a defined customer key, and every config resolves to
      exactly one subscription id.

      Returns one ordered dictionary per template with these keys:
        name                  — folder name (the template identifier)
        folder                — absolute path to the template folder
        main                  — path to main.bicep
        bicep_files           — all *.bicep files in the template folder
        configuration_folder  — path to the configuration/ subfolder
        configuration_files   — *.yml files at the configuration root and in configuration/<customer>/
        environments          — distinct env names across the slots (excluding 'default')
        subscriptions         — distinct resolved subscription names across the slots
        customers             — distinct customer names across the slots (the config subfolders)
        slots                 — one per config file: { name (=config), environment, slot, subscription, customer }
                                (slot/customer empty for a base / shared-platform slot)
        short_name            — the Azure id segment (2-5 alnum, globally unique). DERIVED from the folder name
                                ([Catzc.Azure.Templates.BicepShortName]::Resolve) unless options.yml overrides it
        output_folder         — where Build-Bicep writes main.json + parameters.<subscription>.<slot>.json
        deployment_mode       — 'Incremental' unless overridden by options.yml
        deployment_target     — 'ResourceGroup' unless overridden by options.yml
        environment_kind      — 'standard' unless options.yml sets it; the env-class bit (standard|subscription, see
        [ADR-AZ-DATAMOD](/docs/adr/azure/azure-data-model.md))
        customer_deployment   — whether this is a customer template; defaults to the have_customers variant unless
                                options.yml sets it
        prepost_module        — path to PrePost.psm1 if present (key omitted otherwise)
        resources             — extra files in resources/ if present (key omitted otherwise)

      Returns an empty array if no `infrastructure/templates/` folder exists at the repo root.

      A template's `short_name` is DERIVED from its folder name by default (the first 5 [a-z0-9] characters,
      hyphens dropped via
      [Catzc.Azure.Templates.BicepShortName]::Resolve. A template MAY override it (and/or declare
      `deployment_mode` / `deployment_target` / `environment_kind`) in an OPTIONAL `options.yml` beside
      `main.bicep`; Read-BicepTemplateOptions validates it (strict schema) and the values overlay the
      defaults here. Templates with no options.yml take the derived short_name and the mode/target defaults.
    examples:
      - Get-BicepTemplates | Format-Table name, deployment_target, environments
---
#>

# cspell:ignore etlco
function Get-BicepTemplates {
    param()

    $infrastructureRoot = Get-BicepTemplatesRoot
    $outputRoot = Get-BicepTemplatesOutputRoot

    if ($null -eq $ExecutionContext.SessionState.PSVariable.GetValue('script:bicepTemplatesCache')) {
        $script:bicepTemplatesCache = @{}
    }
    $cacheKey = "$infrastructureRoot|$outputRoot"
    if ($script:bicepTemplatesCache.ContainsKey($cacheKey)) {
        return , $script:bicepTemplatesCache[$cacheKey]
    }

    if (-not (Test-Path $infrastructureRoot -PathType Container)) {
        return @()
    }

    $azure = Get-Config -Config azure

    $templates = [System.Collections.Generic.List[object]]::new()
    foreach ($folderPath in ([System.IO.Directory]::EnumerateDirectories($infrastructureRoot) | Sort-Object)) {
        $name = [System.IO.Path]::GetFileName($folderPath)

        $main = Join-Path $folderPath 'main.bicep'
        Assert-PathExist $main -PathType Leaf

        $configurationFolder = Join-Path $folderPath 'configuration'
        Assert-PathExist $configurationFolder -PathType Container

        $options = Read-BicepTemplateOptions $folderPath
        $environmentKind = if ($options.Contains('environment_kind')) {
            "$($options.environment_kind)"
        }
        else {
            'standard'
        }

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

        $shortNameOverride = if ($options.Contains('short_name')) {
            "$($options.short_name)"
        }
        else {
            $null
        }
        $shortName = [Catzc.Azure.Templates.BicepShortName]::Resolve($name, $shortNameOverride)

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
