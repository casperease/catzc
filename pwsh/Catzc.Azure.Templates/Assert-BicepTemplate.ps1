<#
---
catzc:
  immutable:
    with_body_sha: "7c1f1c8e1f21"
  edges:
    test: pwsh/Catzc.Azure.Templates/tests/Assert-BicepTemplate.Tests.ps1
    docs: "[Assert-BicepTemplate.ps1.md](../../docs/references/pwsh/catzc-azure-templates/Assert-BicepTemplate.ps1.md)"
    cites:
      - ADR-AZ-DATAMOD-PARAMETERCONTRACT
---
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
        $hasPrePost = Test-Path (Join-Path $templateFolderPath 'PrePost.psm1') -PathType Leaf
        $configEntries = [System.Collections.Generic.List[object]]::new()
        $configFolders = @([pscustomobject]@{ path = $configFolder; customer = '' }) + @(
            [System.IO.Directory]::EnumerateDirectories($configFolder) | Sort-Object |
                ForEach-Object { [pscustomobject]@{ path = $_; customer = [System.IO.Path]::GetFileName($_) } })
        foreach ($folder in $configFolders) {
            $files = @(@([System.IO.Directory]::EnumerateFiles($folder.path, '*.yml')) + @([System.IO.Directory]::EnumerateFiles($folder.path, '*.bicepparam')) | Sort-Object)
            $relativeFolder = if ($folder.customer) {
                "configuration/$($folder.customer)"
            }
            else {
                'configuration'
            }
            foreach ($pair in @($files | Group-Object { [System.IO.Path]::GetFileNameWithoutExtension($_) } | Where-Object Count -GT 1)) {
                $errors.Add("[$name] has both $relativeFolder/$($pair.Name).yml and $relativeFolder/$($pair.Name).bicepparam for one coordinate; keep one")
            }
            foreach ($file in $files) {
                if ([System.IO.Path]::GetExtension($file) -eq '.bicepparam') {
                    try {
                        Assert-BicepParamSlot -File $file -Main $main -Template $name -HasPrePost $hasPrePost
                    }
                    catch {
                        $errors.Add("[$name] $($_.Exception.Message)")
                    }
                }
                $configEntries.Add([pscustomobject]@{ file = $file; customer = $folder.customer })
            }
        }

        $nonDefault = @($configEntries | Where-Object { [IO.Path]::GetFileNameWithoutExtension($_.file) -ne 'default' })
        if ($nonDefault.Count -eq 0) {
            $errors.Add("[$name] has no config files under configuration/")
        }

        foreach ($entry in $nonDefault) {
            $configName = [IO.Path]::GetFileNameWithoutExtension($entry.file)
            $extension = [IO.Path]::GetExtension($entry.file)
            $location = if ([string]::IsNullOrEmpty($entry.customer)) {
                "configuration/$configName$extension"
            }
            else {
                "configuration/$($entry.customer)/$configName$extension"
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
            if ($declaredParameters.Count -gt 0 -and $extension -eq '.bicepparam') {
                $text = [System.IO.File]::ReadAllText($entry.file)
                foreach ($parameterName in @([regex]::Matches($text, '(?m)^\s*param\s+([A-Za-z_][A-Za-z0-9_]*)\s*=') | ForEach-Object { $_.Groups[1].Value })) {
                    if ($parameterName -notin $declaredParameters) {
                        $errors.Add("[$name] $location sets parameter '$parameterName', which main.bicep does not declare")
                    }
                }
            }
            elseif ($declaredParameters.Count -gt 0) {
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
