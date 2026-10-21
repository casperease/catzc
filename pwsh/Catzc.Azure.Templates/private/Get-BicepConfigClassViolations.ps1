<#
---
catzc:
  immutable:
    with_body_sha: "9fa2093dd484"
  edges:
    docs: "[Get-BicepConfigClassViolations.ps1.md](docs/references/pwsh/catzc-azure-templates/private/Get-BicepConfigClassViolations.ps1.md)"
    cites:
      - ADR-AZ-DATAMOD-SCHEMAANDINTEGRITY
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
