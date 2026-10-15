<#
---
catzc:
  derived:
    path: automation/Catzc.Azure.Templates/Build-Bicep.ps1
    kind: writer-function
    module: Catzc.Azure.Templates
    visibility: public
    adrs:
      - ADR-AZ-DATAMOD#10
      - ADR-PWSH-ERROR#8
      - ADR-PWSH-PREPOST
---
#>

<#
.SYNOPSIS
    Builds a bicep template: renders per-slot parameter files and compiles main.bicep.
.DESCRIPTION
    The output folder is wiped on every call, so no render from an earlier run survives.
.PARAMETER Template
    Template name (folder under infrastructure/templates/).
.PARAMETER Environments
    Omitted means every slot configured for the template, one parameters file per non-default config.
.PARAMETER Customers
    Optional filter — build only the named customers' slots (their configuration subfolders).
.PARAMETER Shared
    Combines with -Customers as a union, never an intersection; with neither filter every slot builds.
.EXAMPLE
    Build-Bicep discovery
.EXAMPLE
    Build-Bicep discovery -Environments dev
.EXAMPLE
    Build-Bicep discovery -Customers apex
.EXAMPLE
    Build-Bicep foundation -Shared
#>
function Build-Bicep {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'ArgumentCompleter scriptblocks require PowerShell''s fixed 5-parameter completer signature; only $fakeBoundParameters is used, but the other four are mandatory and cannot be removed')]
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        [ArgumentCompleter({ Get-BicepTemplateNames })]
        [ValidateScript({ $_ -in (Get-BicepTemplateNames) })]
        [string] $Template,

        [string[]] $Environments,

        [ArgumentCompleter({
                param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)
                Get-BicepTemplateCustomers -Template $fakeBoundParameters['Template']
            })]
        [string[]] $Customers,

        [switch] $Shared
    )

    $templateDescriptor = Get-BicepTemplate $Template
    $outputFolder = $templateDescriptor.output_folder

    # -Customers and -Shared are unioned when both are given, never intersected.
    # [comment:4](/docs/references/automation/catzc-azure-templates/Build-Bicep.ps1.md#comment4)
    $targetSlots = @($templateDescriptor.slots)
    if ($Environments) {
        $targetSlots = @($targetSlots | Where-Object { $_.environment -in $Environments })
    }
    if ($Customers -or $Shared) {
        $targetSlots = @($targetSlots | Where-Object {
                ($Customers -and $_.customer -in $Customers) -or ($Shared -and $_.customer -eq '')
            })
    }
    if ($targetSlots.Count -eq 0) {
        throw "No slots to build for template '$Template' (requested environments: $($Environments -join ', '); customers: $($Customers -join ', ')$(if ($Shared) { ' + shared' }); available environments: $($templateDescriptor.environments -join ', '))"
    }

    # Checked before the wipe: without the Bicep CLI, az bicep build can exit 0 and write no main.json.
    # [comment:5](/docs/references/automation/catzc-azure-templates/Build-Bicep.ps1.md#comment5)
    Assert-AzCliBicep

    if (Test-Path $outputFolder -PathType Container) {
        Remove-Item $outputFolder -Recurse -Force
    }
    New-Item -ItemType Directory -Path $outputFolder -Force | Out-Null

    # An absent hook is a no-op, and the assets PrePost.psm1 starter is never loaded, only copied into templates.
    # [comment:6](/docs/references/automation/catzc-azure-templates/Build-Bicep.ps1.md#comment6)
    $prepareHook = $null
    $havePrePost = $null -ne $templateDescriptor.prepost_module
    if ($havePrePost) {
        Write-Message "Importing per-template PrePost module: $($templateDescriptor.prepost_module)"
        $prepostModule = Import-Module $templateDescriptor.prepost_module -Scope Local -Force -PassThru
        # The template's hooks run strict like every catzc module, whoever wrote them.
        # [comment:7](/docs/references/automation/catzc-azure-templates/Build-Bicep.ps1.md#comment7)
        . $prepostModule { Set-StrictMode -Version Latest }
        if ($prepostModule.ExportedCommands.ContainsKey('Invoke-BicepPrepareParameterSet')) {
            $prepareHook = $prepostModule.ExportedCommands['Invoke-BicepPrepareParameterSet']
        }
    }

    foreach ($slot in $targetSlots) {
        $environment = $slot.environment
        $configurationDescriptor = Get-BicepTemplateConfiguration $Template $environment -Slot $slot.slot -Customer $slot.customer

        $flat = $configurationDescriptor | ConvertTo-FlatSettingSet
        foreach ($key in $flat.Keys) {
            # Case-sensitive string compare: -eq would coerce a boolean true to equal any non-empty string.
            # [comment:8](/docs/references/automation/catzc-azure-templates/Build-Bicep.ps1.md#comment8)
            if ($flat[$key] -is [string] -and 'UNDEFINED' -ceq $flat[$key]) {
                throw "Undefined config key '$key' for slot '$($slot.name)' in template '$Template'"
            }
        }

        # Resolved before the PrePost hook, so the hook and the parameters file see only ARM entries.
        # [comment:9](/docs/references/automation/catzc-azure-templates/Build-Bicep.ps1.md#comment9)
        if ($configurationDescriptor.Contains('ParametersFile') -and $configurationDescriptor.ParametersFile -is [System.Collections.IDictionary] -and
            $configurationDescriptor.ParametersFile.Contains('parameters') -and $configurationDescriptor.ParametersFile.parameters -is [System.Collections.IDictionary]) {
            $configFolder = if ([string]::IsNullOrEmpty($slot.customer)) {
                $templateDescriptor.configuration_folder
            }
            else {
                Join-Path $templateDescriptor.configuration_folder $slot.customer
            }
            $configurationDescriptor.ParametersFile.parameters = Resolve-BicepParameterAddresses -Parameters $configurationDescriptor.ParametersFile.parameters -ConfigFile (Join-Path $configFolder "$($slot.name).yml")
        }

        # Hooks read from this bag, so adding a dimension never changes the hook signature.
        # [comment:10](/docs/references/automation/catzc-azure-templates/Build-Bicep.ps1.md#comment10)
        $buildInvocation = [ordered]@{
            Template     = $Template
            Environment  = $environment
            Slot         = $slot.slot
            Subscription = $slot.subscription
            Customer     = $slot.customer
        }
        $preparedDescriptor = if ($prepareHook) {
            & $prepareHook -BuildInvocation $buildInvocation -TemplateDescriptor $templateDescriptor -ConfigurationDescriptor $configurationDescriptor
        }
        else {
            $configurationDescriptor
        }

        Assert-True ($null -ne $preparedDescriptor) -ErrorText "PrePost Invoke-BicepPrepareParameterSet returned null for $Template / $($slot.name)"
        if (-not $preparedDescriptor.Contains('ParametersFile')) {
            throw "Prepared configuration for $Template / $($slot.name) is missing 'ParametersFile' (check the template's PrePost.psm1)"
        }

        $paramsPath = Join-Path $outputFolder (Get-BicepParametersFileName -Environment $environment -Slot $slot.slot -Customer $slot.customer)
        $preparedDescriptor.ParametersFile | ConvertTo-Json -Depth 10 | Set-Content $paramsPath -Encoding utf8 -NoNewline
        Write-Message "Wrote $paramsPath"
    }

    Write-Message "Building $($templateDescriptor.main) to $outputFolder"
    Invoke-AzCli "bicep build --file `"$($templateDescriptor.main)`" --outdir `"$outputFolder`""

    # Exit 0 can still mean no main.json; checking here names the real culprit, not a later missing-file.
    # [comment:11](/docs/references/automation/catzc-azure-templates/Build-Bicep.ps1.md#comment11)
    $mainJson = Join-Path $outputFolder 'main.json'
    Assert-PathExist $mainJson -PathType Leaf -ErrorText (
        "az bicep build reported success (exit 0) but wrote no main.json to '$outputFolder'. " +
        'The Bicep CLI was verified available before the build, so this is an unexpected build ' +
        "failure — check the 'az bicep build' output above for warnings or errors."
    )

    if ($havePrePost) {
        Copy-Item $templateDescriptor.prepost_module $outputFolder
    }

    if ($null -ne $templateDescriptor.resources) {
        $resourcesOut = Join-Path $outputFolder 'resources'
        New-Item -ItemType Directory -Path $resourcesOut -Force | Out-Null
        foreach ($file in $templateDescriptor.resources) {
            Copy-Item $file $resourcesOut
        }
    }

    $outputFolder
}
