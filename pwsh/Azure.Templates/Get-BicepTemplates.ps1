# cspell:ignore etlco
function Get-BicepTemplates {
    param()

    $infrastructureRoot = Get-BicepTemplatesRoot
    $outputRoot = Get-BicepTemplatesOutputRoot

    # Cached for the session by discovery root and output root; only a re-import invalidates, and callers treat the shared result as read-only.
    if ($null -eq $ExecutionContext.SessionState.PSVariable.GetValue('script:bicepTemplatesCache')) {
        # Strict-safe probe of the lazy cache entry.
        $script:bicepTemplatesCache = @{}
    }
    $cacheKey = "$infrastructureRoot|$outputRoot"
    if ($script:bicepTemplatesCache.ContainsKey($cacheKey)) {
        return , $script:bicepTemplatesCache[$cacheKey]
    }

    if (-not (Test-Path $infrastructureRoot -PathType Container)) {
        return @()
    }

    # A config sits at the configuration root (shared platform) or under configuration/<customer>/; both coordinate checks run here at discovery.
    $azure = Get-Config -Config azure

    $templates = [System.Collections.Generic.List[object]]::new()
    $walk = Get-Config -Config folder-walk
    # Get-ChildPath returns the folders sorted ordinally, so discovery is deterministic, without Get-ChildItem's per-call provider overhead.
    foreach ($folderPath in (Get-ChildPath $infrastructureRoot -Depth 1 -Directory)) {
        $name = [System.IO.Path]::GetFileName($folderPath)

        $main = Join-Path $folderPath 'main.bicep'
        Assert-PathExist $main -PathType Leaf

        $configurationFolder = Join-Path $folderPath 'configuration'
        Assert-PathExist $configurationFolder -PathType Container

        $options = Read-BicepTemplateOptions $folderPath

        # short_name derives from the folder name unless overridden; BicepShortName throws, naming the template, when neither works.
        $shortNameOverride = if ($options.Contains('short_name')) {
            "$($options.short_name)"
        }
        else {
            $null
        }
        $shortName = [Catzc.Azure.Templates.BicepShortName]::Resolve($name, $shortNameOverride)

        $hasPrePost = Test-Path (Join-Path $folderPath 'PrePost.psm1') -PathType Leaf
        # Root configs first, then the customer subfolders, each sorted, so the output stays deterministic.
        $configEntries = [System.Collections.Generic.List[object]]::new()
        $configFolders = @([pscustomobject]@{ path = $configurationFolder; customer = '' }) + @(
            Get-ChildPath $configurationFolder -Depth 1 -Directory |
                ForEach-Object { [pscustomobject]@{ path = $_; customer = [System.IO.Path]::GetFileName($_) } })
        foreach ($configFolder in $configFolders) {
            $files = @([Catzc.Base.Folders.PathSet]::new($walk).AddPattern($configFolder.path, '*.yml',
                    1).AddPattern($configFolder.path, '*.bicepparam', 1).ToArray())
            # A yml beside a bicepparam of the same name is no slot: it may hold only ResourceGroup.
            $siblings = @($files | Where-Object {
                    [System.IO.Path]::GetExtension($_) -eq '.yml' -and
                    [System.IO.File]::Exists([System.IO.Path]::ChangeExtension($_, '.bicepparam'))
                })
            foreach ($sibling in $siblings) {
                Assert-BicepParamSibling -File $sibling -Template $name
            }
            foreach ($file in @($files | Where-Object { $_ -notin $siblings })) {
                if ([System.IO.Path]::GetExtension($file) -eq '.bicepparam') {
                    Assert-BicepParamSlot -File $file -Main $main -Template $name -HasPrePost $hasPrePost
                }
                $configEntries.Add([pscustomobject]@{ file = $file; customer = $configFolder.customer })
            }
        }

        # One config file is one slot: one (customer, env, slot) coordinate, one subscription, one resource group; default.yml is a reserved skip.
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
            $customerViolations = Get-BicepCustomerClassViolations -Customer $entry.customer -Location $location
            if ($customerViolations) {
                throw "Template '$name' has an invalid config: $($customerViolations -join '; ')."
            }

            $subscription = Get-BicepConfigSubscriptionCandidates -Customer $entry.customer -Environment $resolved.environment -AzureConfig $azure |
                Select-Object -First 1
            $slots.Add([Catzc.Azure.Templates.BicepSlot]::new($configName, $resolved.environment, $resolved.slot,
                    $subscription, $entry.customer, $entry.file))
        }
        $environments = @($slots | ForEach-Object { $_.environment } | Select-Object -Unique)
        # The template's env class is inferred from its slots, so slots that mix the two classes are the one class violation.
        $classViolations = Get-BicepConfigClassViolations -Environment $environments -AzureConfig $azure -Location 'configuration/'
        if ($classViolations) {
            throw "Template '$name' has an invalid config: $($classViolations -join '; ')."
        }
        $perSubscriptionEnvironments = @($azure.environments.Keys | Where-Object {
                $azure.environments[$_].Contains('per_subscription') -and $azure.environments[$_]['per_subscription']
            })
        $subscriptions = @($slots | ForEach-Object { $_.subscription } | Select-Object -Unique)
        $customers = @($slots | Where-Object { $_.customer } | ForEach-Object { $_.customer } | Select-Object -Unique)

        $bicepFiles = @([Catzc.Base.Folders.PathSet]::new($walk).AddPattern($folderPath, '*.bicep', 1).ToArray())

        $template = [ordered]@{
            name                          = $name
            folder                        = $folderPath
            main                          = $main
            bicep_files                   = $bicepFiles
            configuration_folder          = $configurationFolder
            configuration_files           = $configurationFiles.ToArray()
            environments                  = $environments
            subscriptions                 = $subscriptions
            customers                     = $customers
            slots                         = $slots.ToArray()
            short_name                    = $shortName.value
            output_folder                 = Join-Path $outputRoot "template/$name"
            deployment_mode               = 'Incremental'
            deployment_target             = 'ResourceGroup'
            # BicepTemplate infers environment_kind and customer_deployment from the slots.
            per_subscription_environments = $perSubscriptionEnvironments
        }

        # short_name is already applied above, so the overlay skips it.
        foreach ($key in @($options.Keys)) {
            if ($key -eq 'short_name') {
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
            $template['resources'] = @([Catzc.Base.Folders.PathSet]::new($walk).AddPattern($resourcesFolder, '*',
                    1).ToArray())
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
