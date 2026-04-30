<#
.SYNOPSIS
    Validates a bicep template (or all templates) against its options.yml and the azure config,
    collecting every problem and throwing one consolidated error. The explicit, author/CI-facing
    counterpart to the fail-fast checks Get-BicepTemplates runs at discovery.
.DESCRIPTION
    Where Get-BicepTemplates enforces the rules at discovery and throws on the first violation (so a
    bad template makes the whole module fail to load), Assert-BicepTemplate scans a template folder
    directly and reports ALL of its problems at once — so it can describe a template that discovery
    would reject. The two share the per-config rule (Get-BicepConfigClassViolations), so they never drift.

    Checks (all collected, then thrown together):
      - main.bicep exists; configuration/ exists with at least one (non-default) config.
      - options.yml (optional) is schema-valid (Read-BicepTemplateOptions); short_name is resolved from the
        folder name (or the options.yml override) via BicepShortName and — when validating all templates —
        globally unique.
      - Env-class classification: every config matches the template's env-class bit
        (standard/subscription) — via Get-BicepConfigClassViolations. (Slot is per-config: a template
        may mix slotted and non-slotted configs.)
      - Identity references: each config filename resolves to a defined environment; each config sits
        under a configuration/<subscription>/ folder that is a defined subscription serving that env
        (Get-BicepSubscriptionConfigViolations); no config sits directly under configuration/.
      - Parameter alignment: a config's ParametersFile.parameters may only set parameters that
        main.bicep declares (params main.bicep declares but the config omits are fine — PrePost or
        bicep defaults supply them).
      - With -Build: `az bicep build` compiles main.bicep (needs az; opt-in, slower).
.PARAMETER Template
    Template name to validate. Omit to validate every template under infrastructure/templates/.
.PARAMETER Build
    Also compile main.bicep with `az bicep build` (requires az CLI). Off by default.
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
        # [System.IO.Directory] (sorted) instead of Get-ChildItem — see Get-BicepTemplates for the
        # ~20ms-per-call Get-ChildItem overhead this avoids.
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

        # Customer-class bit — defaults to the have_customers variant unless options.yml sets it; an explicit
        # customer_deployment: true is only allowed when customers are enabled (see customer-model ADR).
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

        # short_name is derived from the folder name unless options.yml overrides it. BicepShortName owns the
        # derivation + format validation (throws on a malformed override, or a folder that cannot derive a
        # valid short_name without one); the resolved value feeds the global-uniqueness check.
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

        # Gather configs: every config lives under a configuration/<subscription>/ folder.
        $configEntries = [System.Collections.Generic.List[object]]::new()
        $stray = @([System.IO.Directory]::EnumerateFiles($configFolder, '*.yml') | ForEach-Object { [System.IO.Path]::GetFileName($_) } | Sort-Object)
        if ($stray.Count -gt 0) {
            $errors.Add("[$name] config file(s) directly under configuration/ ($($stray -join ', ')) — every config must live under a configuration/<subscription>/ folder")
        }
        foreach ($subscriptionDirectoryPath in ([System.IO.Directory]::EnumerateDirectories($configFolder) | Sort-Object)) {
            foreach ($file in @([System.IO.Directory]::EnumerateFiles($subscriptionDirectoryPath, '*.yml') | Sort-Object)) {
                $configEntries.Add([pscustomobject]@{ file = $file; subscription = [System.IO.Path]::GetFileName($subscriptionDirectoryPath) })
            }
        }

        $nonDefault = @($configEntries | Where-Object { [IO.Path]::GetFileNameWithoutExtension($_.file) -ne 'default' })
        if ($nonDefault.Count -eq 0) {
            $errors.Add("[$name] has no config files under configuration/<subscription>/")
        }

        foreach ($entry in $nonDefault) {
            $configName = [IO.Path]::GetFileNameWithoutExtension($entry.file)
            $location = "configuration/$($entry.subscription)/$configName.yml"

            $resolved = $null
            try {
                $resolved = Resolve-BicepConfigName $configName
            }
            catch {
                $errors.Add("[$name] $location — $($_.Exception.Message)")
            }
            if ($null -ne $resolved) {
                foreach ($violation in (Get-BicepSubscriptionConfigViolations -Subscription $entry.subscription -Environment $resolved.environment -AzureConfig $azure -Location $location)) {
                    $errors.Add("[$name] $violation")
                }
                foreach ($violation in (Get-BicepConfigClassViolations -Environment $resolved.environment -EnvironmentKind $environmentKind -AzureConfig $azure -Location $location)) {
                    $errors.Add("[$name] $violation")
                }
                foreach ($violation in (Get-BicepCustomerClassViolations -Subscription $entry.subscription -CustomerDeployment $customerDeployment -AzureConfig $azure -Location $location)) {
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
                try {
                    Invoke-AzCli "bicep build --file `"$main`" --stdout" -Silent | Out-Null
                }
                catch {
                    $errors.Add("[$name] az bicep build failed: $($_.Exception.Message)")
                }
            }
        }
    }

    if ($errors.Count -gt 0) {
        throw "Template validation failed:`n$($errors -join "`n")"
    }
}
