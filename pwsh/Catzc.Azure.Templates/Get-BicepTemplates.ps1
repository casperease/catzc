<#
---
catzc:
  immutable:
    with_body_sha: b0add85b199f
  edges:
    test: pwsh/Catzc.Azure.Templates/tests/Get-BicepTemplates.Tests.ps1
    docs: "[Get-BicepTemplates.ps1.md](docs/references/pwsh/catzc-azure-templates/Get-BicepTemplates.ps1.md)"
    cites:
      - ADR-AUTO-CACHE
      - ADR-AZ-CUSTOMER
      - ADR-AZ-DATAMOD
      - ADR-AZ-NAMING-TWOTEMPLATEIDENTIFIERS
      - ADR-PWSH-CACHE-STRICTSAFEPROBE
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

        $hasPrePost = Test-Path (Join-Path $folderPath 'PrePost.psm1') -PathType Leaf
        $configEntries = [System.Collections.Generic.List[object]]::new()
        $configFolders = @([pscustomobject]@{ path = $configurationFolder; customer = '' }) + @(
            [System.IO.Directory]::EnumerateDirectories($configurationFolder) | Sort-Object |
                ForEach-Object { [pscustomobject]@{ path = $_; customer = [System.IO.Path]::GetFileName($_) } })
        foreach ($configFolder in $configFolders) {
            $files = @(@([System.IO.Directory]::EnumerateFiles($configFolder.path, '*.yml')) + @([System.IO.Directory]::EnumerateFiles($configFolder.path, '*.bicepparam')) | Sort-Object)
            $relativeFolder = if ($configFolder.customer) {
                "configuration/$($configFolder.customer)"
            }
            else {
                'configuration'
            }
            # One config per coordinate
            # ([ADR-AZ-DATAMOD-ONEFILEONESUBSCRIPTION](/docs/drs/azure/azure-data-model.md#rule-adr-az-datamod-onefileonesubscription)): never a yml and a bicepparam of one name.
            foreach ($pair in @($files | Group-Object { [System.IO.Path]::GetFileNameWithoutExtension($_) } | Where-Object Count -GT 1)) {
                throw "Template '$name' has both $relativeFolder/$($pair.Name).yml and $relativeFolder/$($pair.Name).bicepparam for one coordinate; keep one."
            }
            foreach ($file in $files) {
                if ([System.IO.Path]::GetExtension($file) -eq '.bicepparam') {
                    Assert-BicepParamSlot -File $file -Main $main -Template $name -HasPrePost $hasPrePost
                }
                $configEntries.Add([pscustomobject]@{ file = $file; customer = $configFolder.customer })
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
            $extension = [System.IO.Path]::GetExtension($entry.file)
            $location = if ([string]::IsNullOrEmpty($entry.customer)) {
                "configuration/$configName$extension"
            }
            else {
                "configuration/$($entry.customer)/$configName$extension"
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
            $slots.Add([Catzc.Azure.Templates.BicepSlot]::new($configName, $resolved.environment, $resolved.slot, $subscription, $entry.customer, $entry.file))
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
