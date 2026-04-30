<#
.SYNOPSIS
    Returns the env-class violations for a single resolved config — the shared rule used by both
    Get-BicepTemplates (fail-fast at discovery) and Assert-BicepTemplate (collect-all), so the two
    never drift. See docs/adr/azure/data-model.md#rule-adr-datamod8.
.DESCRIPTION
    Checks one config against the template's env-class bit and returns a (possibly empty) array of
    human-readable violation strings:
      - env-class bit: subscription ⇒ the config env must be a per_subscription env (subn/subp);
                       standard ⇒ it must be a standard env.
    The slot is a per-config dimension, not a template-level bit — a template may freely mix slotted
    (<env>-<slot>.yml) and non-slotted (<env>.yml) configs — so there is no slot rule here.
    Empty result means the config conforms.
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
        $violations += "$Location uses standard env '$Environment', but the template is environment_kind 'subscription' — use a per-subscription env (subn/subp)"
    }
    if ($EnvironmentKind -eq 'standard' -and $environmentPerSubscription) {
        $violations += "$Location uses per-subscription env '$Environment', but the template is environment_kind 'standard' — set 'environment_kind: subscription' in options.yml"
    }

    $violations
}
