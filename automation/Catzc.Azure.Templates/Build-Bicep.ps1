<#
---
catzc:
  immutable:
    path: automation/Catzc.Azure.Templates/Build-Bicep.ps1
    name: build-bicep
    filetype: ps1
    kind: function
    subkind: writer
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Azure.Templates
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    page: docs/references/automation/catzc-azure-templates/Build-Bicep.ps1.md
    test: automation/Catzc.Azure.Templates/tests/Build-Bicep.Tests.ps1
    cites:
      - ADR-AZ-DATAMOD#10
      - ADR-PWSH-ERROR#8
      - ADR-PWSH-PREPOST
  config:
    synopsis: 'Builds a bicep template: renders per-slot parameter files and compiles main.bicep.'
    description: |-
      For each target slot (one per configuration/[<customer>/]<config>.yml):
      1. Loads the slot's config via Get-BicepTemplateConfiguration.
      2. Runs the UNDEFINED guard (throws if any flattened leaf is the literal string 'UNDEFINED').
      3. Resolves every config-addressed parameter, `{ address: global.<config>.<key>… }`, into `{ value: … }`
         through Get-ConfigValue (Resolve-BicepParameterAddresses). An address reaches only version-controlled
         config, so no secret can be addressed: a secure parameter takes a Key Vault `reference`. An address that
         does not resolve, or one set together with `value` or `reference`, fails the build, naming the config file
         and the parameter.
      4. If the template ships `infrastructure/templates/<name>/PrePost.psm1` exporting
         Invoke-BicepPrepareParameterSet, runs it — the merge seam between per-slot config and the
         global asset configs in `Catzc.Azure.Templates/assets/*.yml`. With no such hook the step is a no-op
         (the per-slot config is used unchanged).
      5. Renders the resulting `.ParametersFile` to
         `out/template/<name>/parameters.[<customer>.]<config>.json` — one per config file; the name
         comes from Get-BicepParametersFileName (config name = `<env>[-<slot>]`).

      Then runs `az bicep build --file <main.bicep> --outdir <out>` once for the template,
      producing `main.json`. Finally copies the per-template `PrePost.psm1` (if any) and the
      contents of `resources/` (if any) into the output folder.

      The output folder is wiped and recreated on every call.
    parameters:
      Template: Template name (folder under infrastructure/templates/).
      Environments: |-
        Optional filter — build only slots whose environment is named here. Defaults to all
        slots configured for the template (one parameters file per configuration/*.yml, excluding default).
      Customers: Optional filter — build only the named customers' slots (their configuration subfolders).
      Shared: |-
        Optional filter — build the configuration-root (shared-platform, non-customer) slots. Combines with
        -Customers as a union; with neither filter every slot builds.
    examples:
      - Build-Bicep discovery
      - Build-Bicep discovery -Environments dev
      - Build-Bicep discovery -Customers apex
      - Build-Bicep foundation -Shared
---
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

    Assert-AzCliBicep

    if (Test-Path $outputFolder -PathType Container) {
        Remove-Item $outputFolder -Recurse -Force
    }
    New-Item -ItemType Directory -Path $outputFolder -Force | Out-Null

    $prepareHook = $null
    $havePrePost = $null -ne $templateDescriptor.prepost_module
    if ($havePrePost) {
        Write-Message "Importing per-template PrePost module: $($templateDescriptor.prepost_module)"
        $prepostModule = Import-Module $templateDescriptor.prepost_module -Scope Local -Force -PassThru
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
            if ($flat[$key] -is [string] -and 'UNDEFINED' -ceq $flat[$key]) {
                throw "Undefined config key '$key' for slot '$($slot.name)' in template '$Template'"
            }
        }

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
