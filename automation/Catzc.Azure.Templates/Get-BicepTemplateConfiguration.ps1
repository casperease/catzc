<#
.SYNOPSIS
    Loads a template's per-slot config (configuration/<slot>.yml) and returns the ordered dictionary.
.DESCRIPTION
    Returns the parsed yml as an ordered dictionary — typically just a `ParametersFile` (the
    template's ARM parameters, written statically). No merge with global config happens here;
    PrePost's Invoke-BicepPrepareParameterSet is the merge seam. The resource-group name is not
    read from this file — it is derived by Get-BicepResourceGroupName.
.PARAMETER Template
    Template name (folder under infrastructure/templates/).
.PARAMETER Environment
    Environment shortname. Must be configured for the template.
.PARAMETER Slot
    Optional special-slot discriminator — 1-3 lowercase alphanumeric chars (`001`, `blu`, …). Selects
    `<env>-<slot>.yml`; omitted selects the env's base slot `<env>.yml`. The selected config must exist.
.PARAMETER Subscription
    Optional subscription (a key in azure.yml's subscriptions). Selects the config under
    `configuration/<subscription>/`. Omitted ⇒ resolved from (template, env, slot); required only when
    more than one subscription has that config (Resolve-BicepDeploymentSubscription).
.EXAMPLE
    $configuration = Get-BicepTemplateConfiguration sample dev
.EXAMPLE
    $configuration = Get-BicepTemplateConfiguration sample dev -Subscription shared_nonprod
.EXAMPLE
    $configuration = Get-BicepTemplateConfiguration indexed-template prod -Slot 001
    $configuration.ParametersFile.parameters.storageAccountName.value
#>
function Get-BicepTemplateConfiguration {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'ArgumentCompleter scriptblocks require PowerShell''s fixed 5-parameter completer signature; only $fakeBoundParameters is used, but the other four are mandatory and cannot be removed')]
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        [ArgumentCompleter({ Get-BicepTemplates | ForEach-Object { $_.name } })]
        [ValidateScript({ $_ -in (Get-BicepTemplates | ForEach-Object { $_.name }) })]
        [string] $Template,

        [Parameter(Mandatory, Position = 1)]
        [string] $Environment,

        [Parameter(Position = 2)]
        [ArgumentCompleter({
                param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)
                Get-BicepTemplateSlots -Template $fakeBoundParameters['Template'] -Environment $fakeBoundParameters['Environment'] -Customer $fakeBoundParameters['Customer']
            })]
        [string] $Slot,

        [ArgumentCompleter({
                param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)
                Get-BicepTemplateSubscriptions -Template $fakeBoundParameters['Template'] -Environment $fakeBoundParameters['Environment'] -Slot $fakeBoundParameters['Slot']
            })]
        [string] $Subscription
    )

    $templateDescriptor = Get-BicepTemplate $Template

    if (-not [string]::IsNullOrEmpty($Slot) -and $Slot -notmatch '(?-i)^[a-z0-9]{1,3}$') {
        throw "Invalid -Slot '$Slot' — must be 1-3 lowercase alphanumeric chars (e.g. 001)."
    }

    # One config file per (subscription, env, slot): `<subscription>/<env>[-<slot>].yml`. The
    # subscription is the config folder; resolve it from (env, slot) when not given (throws if ambiguous
    # or absent — Resolve-BicepDeploymentSubscription), so the selected config is guaranteed to exist.
    $subscription = Resolve-BicepDeploymentSubscription -Template $Template -Environment $Environment -Slot $Slot -Subscription $Subscription
    $configName = Get-BicepConfigName $Environment $Slot
    $folder = Join-Path $templateDescriptor.configuration_folder $subscription
    $environmentFile = Join-Path $folder "$configName.yml"
    Assert-PathExist $environmentFile -PathType Leaf

    Get-Content $environmentFile -Raw | ConvertFrom-Yaml -Ordered
}
