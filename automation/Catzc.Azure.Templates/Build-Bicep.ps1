<#
.SYNOPSIS
    Builds a bicep template: renders per-slot parameter files and compiles main.bicep.
.DESCRIPTION
    For each target slot (one per configuration/<subscription>/<config>.yml):
    1. Loads `configuration/<subscription>/<slot>.yml` via Get-BicepTemplateConfiguration.
    2. Runs the UNDEFINED gate (throws if any flattened leaf is the literal string 'UNDEFINED').
    3. If the template ships `infrastructure/templates/<name>/PrePost.psm1` exporting
       Invoke-BicepPrepareParameterSet, runs it — the merge seam between per-slot config and the
       global asset configs in `Catzc.Azure.Templates/assets/*.yml`. With no such hook the step is a no-op
       (the per-slot config is used unchanged).
    4. Renders the resulting `.ParametersFile` to
       `out/template/<name>/parameters.<subscription>.<config>.json` — one per config file; the name
       comes from Get-BicepParametersFileName (config name = `<env>[-<slot>]`).

    Then runs `az bicep build --file <main.bicep> --outdir <out>` once for the template,
    producing `main.json`. Finally copies the per-template `PrePost.psm1` (if any) and the
    contents of `resources/` (if any) into the output folder.

    The output folder is wiped and recreated on every call.
.PARAMETER Template
    Template name (folder under infrastructure/templates/).
.PARAMETER Environments
    Optional filter — build only slots whose environment is named here. Defaults to all
    slots configured for the template (one parameters file per configuration/*.yml, excluding default).
.PARAMETER Subscriptions
    Optional filter — build only slots for the named subscriptions (config folders). Defaults to all.
.EXAMPLE
    Build-Bicep discovery
.EXAMPLE
    Build-Bicep discovery -Environments dev
.EXAMPLE
    Build-Bicep discovery -Subscriptions apex_nonprod
#>
function Build-Bicep {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        [ArgumentCompleter({ Get-BicepTemplateNames })]
        [ValidateScript({ $_ -in (Get-BicepTemplateNames) })]
        [string] $Template,

        [string[]] $Environments,

        [string[]] $Subscriptions
    )

    $templateDescriptor = Get-BicepTemplate $Template
    $outputFolder = $templateDescriptor.output_folder

    # Build every slot by default (all subscriptions); -Environments / -Subscriptions narrow it.
    $targetSlots = @($templateDescriptor.slots)
    if ($Environments) {
        $targetSlots = @($targetSlots | Where-Object { $_.environment -in $Environments })
    }
    if ($Subscriptions) {
        $targetSlots = @($targetSlots | Where-Object { $_.subscription -in $Subscriptions })
    }
    if ($targetSlots.Count -eq 0) {
        throw "No slots to build for template '$Template' (requested environments: $($Environments -join ', '); subscriptions: $($Subscriptions -join ', '); available: $($templateDescriptor.environments -join ', '))"
    }

    # Precondition: the Bicep CLI must be available before we wipe the output and render params, else
    # `az bicep build` can exit 0 while writing no main.json (e.g. a missing/blocked auto-install). This
    # also warms the install in its own call, separate from the build. See Assert-AzCliBicep.
    Assert-AzCliBicep

    if (Test-Path $outputFolder -PathType Container) {
        Remove-Item $outputFolder -Recurse -Force
    }
    New-Item -ItemType Directory -Path $outputFolder -Force | Out-Null

    # A template MAY ship its own infrastructure/templates/<name>/PrePost.psm1 exporting a build-time
    # Invoke-BicepPrepareParameterSet hook. Resolve it once if present; absent -> the prepare step
    # is a no-op (the per-slot config is used unchanged). The assets/PrePost.psm1 starter is never
    # loaded here — it exists only to be copied into a template.
    $prepareHook = $null
    $havePrePost = $null -ne $templateDescriptor.prepost_module
    if ($havePrePost) {
        Write-Message "Importing per-template PrePost module: $($templateDescriptor.prepost_module)"
        $prepostModule = Import-Module $templateDescriptor.prepost_module -Scope Local -Force -PassThru
        if ($prepostModule.ExportedCommands.ContainsKey('Invoke-BicepPrepareParameterSet')) {
            $prepareHook = $prepostModule.ExportedCommands['Invoke-BicepPrepareParameterSet']
        }
    }

    foreach ($slot in $targetSlots) {
        $environment = $slot.environment
        $configurationDescriptor = Get-BicepTemplateConfiguration $Template $environment -Slot $slot.slot -Subscription $slot.subscription

        $flat = $configurationDescriptor | ConvertTo-FlatSettingSet
        foreach ($key in $flat.Keys) {
            if ($flat[$key] -eq 'UNDEFINED') {
                throw "Undefined config key '$key' for slot '$($slot.name)' in template '$Template'"
            }
        }

        # The build invocation for this slot — the arguments Build-Bicep is acting on. Hooks read what
        # they need from it (e.g. $BuildInvocation.Customer) rather than via raw params, so adding a
        # dimension never changes the hook signature.
        # See docs/adr/automation/powershell/prepost-extension-modules.md.
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

        $paramsPath = Join-Path $outputFolder (Get-BicepParametersFileName -Environment $environment -Slot $slot.slot -Subscription $slot.subscription)
        $preparedDescriptor.ParametersFile | ConvertTo-Json -Depth 10 | Set-Content $paramsPath -Encoding utf8 -NoNewline
        Write-Message "Wrote $paramsPath"
    }

    Write-Message "Building $($templateDescriptor.main) to $outputFolder"
    Invoke-AzCli "bicep build --file `"$($templateDescriptor.main)`" --outdir `"$outputFolder`""

    # az bicep build can exit 0 yet emit nothing. Assert the compiled template at the source so the
    # failure names the real culprit here, not later as a generic missing-file in
    # Get-BicepDeploymentContext. Assert-AzCliBicep already proved the Bicep CLI is available above, so a
    # missing main.json now is an unexpected build failure, not a not-installed one — say exactly that.
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
