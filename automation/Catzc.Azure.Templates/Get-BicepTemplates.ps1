# cspell:ignore etlco
<#
.SYNOPSIS
    Discovers all bicep templates under $(Get-RepositoryRoot)/infrastructure/templates.
.DESCRIPTION
    Scans `infrastructure/templates/` at depth 1 for template folders (reusable bicep modules live
    in the sibling `infrastructure/modules/` and are NOT discovered here). Each folder must contain
    a `main.bicep` and a `configuration/` subfolder. A config lives at the configuration ROOT —
    `configuration/<env>[-<slot>].yml`, a shared-platform deployment — or under a customer subfolder,
    `configuration/<customer>/<env>[-<slot>].yml`, where the folder is always a customer KEY from
    customer.yml. One config file ⟷ one resource group (docs/adr/azure/azure-data-model.md). The filename
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
      slots                 — one per config file: { name (=config), environment, slot, subscription, customer } (slot/customer empty for a base / shared-platform slot)
      short_name            — the Azure id segment (2-5 alnum, globally unique). DERIVED from the folder name
                              ([Catzc.Azure.Templates.BicepShortName]::Resolve) unless options.yml overrides it
      output_folder         — where Build-Bicep writes main.json + parameters.<subscription>.<slot>.json
      deployment_mode       — 'Incremental' unless overridden by options.yml
      deployment_target     — 'ResourceGroup' unless overridden by options.yml
      environment_kind      — 'standard' unless options.yml sets it; the env-class bit (standard|subscription, see azure-data-model.md)
      customer_deployment   — whether this is a customer template; defaults to the have_customers variant unless options.yml sets it
      prepost_module        — path to PrePost.psm1 if present (key omitted otherwise)
      resources             — extra files in resources/ if present (key omitted otherwise)

    Returns an empty array if no `infrastructure/templates/` folder exists at the repo root.

    A template's `short_name` is DERIVED from its folder name by default (the first 5 [a-z0-9] characters,
    hyphens dropped via
    [Catzc.Azure.Templates.BicepShortName]::Resolve. A template MAY override it (and/or declare
    `deployment_mode` / `deployment_target` / `environment_kind`) in an OPTIONAL `options.yml` beside
    `main.bicep`; Read-BicepTemplateOptions validates it (strict schema) and the values overlay the
    defaults here. Templates with no options.yml take the derived short_name and the mode/target defaults.
.EXAMPLE
    Get-BicepTemplates | Format-Table name, deployment_target, environments
#>
function Get-BicepTemplates {
    param()

    $infrastructureRoot = Get-BicepTemplatesRoot
    $outputRoot = Get-BicepTemplatesOutputRoot

    # Filesystem-derived information is cached for the session, lazily on first use, keyed on the discovery
    # root + the output root — see docs/adr/automation/caching.md. The on-disk file set is fixed at importer time
    # (pipeline: static checkout; devbox: re-run the importer after editing files), so re-running the
    # importer is the only invalidation. Keying on the root lets tests redirect discovery to a fixture
    # tree (Mock Get-BicepTemplatesRoot) or the build output to a folder of their own (Mock
    # Get-BicepTemplatesOutputRoot) without colliding with the real cache entry. Callers must
    # treat the result as read-only (the same object is returned every call).
    if (-not $script:bicepTemplatesCache) {
        $script:bicepTemplatesCache = @{}
    }
    $cacheKey = "$infrastructureRoot|$outputRoot"
    if ($script:bicepTemplatesCache.ContainsKey($cacheKey)) {
        return , $script:bicepTemplatesCache[$cacheKey]
    }

    if (-not (Test-Path $infrastructureRoot -PathType Container)) {
        return @()
    }

    # A config lives at the configuration root (`<env>[-<slot>].yml` — the shared platform) or under a
    # configuration/<customer>/ subfolder (the folder is a customer key). The subscription is resolved
    # per config; both checks (subfolder is a defined customer key, the coordinate resolves to exactly
    # one subscription) run at discovery via the shared Get-BicepSubscriptionConfigViolations.
    $azure = Get-Config -Config azure

    $templates = [System.Collections.Generic.List[object]]::new()
    # Enumerate with [System.IO.Directory] (sorted to keep output deterministic) rather than Get-ChildItem:
    # the cmdlet carries ~20ms of provider overhead PER CALL on Windows, and discovery makes dozens of these
    # calls — it was the dominant cost of a cold discovery (~0.8s of ~1.2s). The raw .NET enumerators are
    # ~0.1ms. Same approach as Resolve-ConfigEntry.
    foreach ($folderPath in ([System.IO.Directory]::EnumerateDirectories($infrastructureRoot) | Sort-Object)) {
        $name = [System.IO.Path]::GetFileName($folderPath)

        $main = Join-Path $folderPath 'main.bicep'
        Assert-PathExist $main -PathType Leaf

        $configurationFolder = Join-Path $folderPath 'configuration'
        Assert-PathExist $configurationFolder -PathType Container

        $options = Read-BicepTemplateOptions $folderPath
        # Env-class template classification (docs/adr/azure/azure-data-model.md): the env-class bit
        # (standard/subscription, default standard). Every config below must match it. The slot is a
        # per-config dimension, not a template bit — a template may mix slotted and non-slotted configs.
        $environmentKind = if ($options.Contains('environment_kind')) {
            "$($options.environment_kind)"
        }
        else {
            'standard'
        }

        # Customer-class bit (docs/adr/azure/azure-customer-model.md): whether this is a customer template. It
        # defaults to the have_customers repo variant (Test-HaveCustomers) unless options.yml sets it. An
        # explicit customer_deployment: true is only allowed when customers are enabled (the repo gate).
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

        # short_name is the Azure id segment every resource name is built from. It is DERIVED from the folder
        # name by default; an options.yml `short_name` overrides it. BicepShortName owns the derivation +
        # format validation (a malformed override, or a folder that cannot yield a valid short_name without an
        # override, throws here — naming the template). See docs/adr/azure/azure-naming-standard.md#rule-adr-naming2.
        $shortNameOverride = if ($options.Contains('short_name')) {
            "$($options.short_name)"
        }
        else {
            $null
        }
        $shortName = [Catzc.Azure.Templates.BicepShortName]::Resolve($name, $shortNameOverride)

        # Gather every config file with its customer (the subfolder; '' for a configuration-root config).
        # Root files first, then the customer subfolders — both sorted, so output stays deterministic.
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

        # Each config file is one slot (one resource group). The filename `<env>[-<slot>]` resolves to
        # its environment + slot via Resolve-BicepConfigName (`default.yml` is a reserved skip); the
        # subscription is resolved from the (customer?, env) coordinate — one config file ⟷ one
        # (customer?, env, slot) ⟷ one subscription ⟷ one RG.
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

            $subscription = @(Get-BicepConfigSubscriptionCandidates -Customer $entry.customer -Environment $resolved.environment -AzureConfig $azure)[0]
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

        # Overlay the remaining deployment overrides. short_name is resolved via BicepShortName and
        # environment_kind / customer_deployment are already applied above, so all three are excluded here.
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
