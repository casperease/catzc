<#
.SYNOPSIS
    Returns the env-class violations for a single resolved config — the shared rule used by both
    Get-BicepTemplates (fail-fast at discovery) and Assert-BicepTemplate (collect-all), so the two
    never drift. See [ADR-AZ-DATAMOD#8](/docs/adr/azure/azure-data-model.md#rule-adr-az-datamod8).
.DESCRIPTION
    The slot is per-config, not a template bit, so a template may mix slotted and non-slotted configs.
    [comment:1](/docs/references/automation/catzc-azure-templates/private/Get-BicepConfigClassViolations.ps1.md#comment1)
.PARAMETER Environment
    The config's resolved environment name.
.PARAMETER EnvironmentKind
    The template's env-class bit ('standard' or 'subscription').
.PARAMETER AzureConfig
    The loaded azure config (Get-Config -Config azure) — used to read the env's per_subscription flag.
.PARAMETER Location
    A human-readable label for the config (e.g. 'configuration/apex/dev.yml') used in messages.
#>
function Get-BicepConfigClassViolations {
    [CmdletBinding()]
    [OutputType([string[]])]
    param(
        [Parameter(Mandatory)] [string] $Environment,
        [Parameter(Mandatory)] [string] $EnvironmentKind,
        [Parameter(Mandatory)] $AzureConfig,
        [Parameter(Mandatory)] [string] $Location
    )

    $violations = @()

    $environmentEntry = $AzureConfig.environments[$Environment]
    $environmentPerSubscription = ($null -ne $environmentEntry -and $environmentEntry.Contains('per_subscription') -and $environmentEntry['per_subscription'])
    if ($EnvironmentKind -eq 'subscription' -and -not $environmentPerSubscription) {
        $violations += "$Location uses standard env '$Environment', but the template is environment_kind 'subscription' — use a per-subscription env (nsub/psub)"
    }
    if ($EnvironmentKind -eq 'standard' -and $environmentPerSubscription) {
        $violations += "$Location uses per-subscription env '$Environment', but the template is environment_kind 'standard' — set 'environment_kind: subscription' in options.yml"
    }

    $violations
}
