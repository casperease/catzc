<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Azure.Templates/private/Get-BicepConfigClassViolations.ps1
    folder: private
    name: get-bicep-config-class-violations
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Azure.Templates
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: private
  edges:
    cites:
      - ADR-AZ-DATAMOD#8
---
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
