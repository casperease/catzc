<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/Get-TestTargetSkipReason.ps1
    kind: function
    module: Catzc.Base.QualityGates
    visibility: public
    adrs:
      - ADR-AUTO-TEST#41
      - ADR-AUTO-TEST#8
---
#>

<#
.SYNOPSIS
    Says why an L4 test must skip against its target environment, or nothing when it may run.
.DESCRIPTION
    The only limit on an L4 run is the console's security context, so each test asks here first and self-skips.
.PARAMETER Environment
    The target environment the test reaches, e.g. pre-prod or production.
.PARAMETER Mode
    A Synthetic test skips on an environment that test-policy.yml limits to read-only, which is the default.
.PARAMETER Probe
    A probe that throws counts as unreachable, so the test skips instead of failing.
.OUTPUTS
    [string] the skip key, or nothing when the test may run.
.EXAMPLE
    It 'answers on its health endpoint' -Tag 'L4', 'integrity' {
        $skip = Get-TestTargetSkipReason -Environment production -Mode ReadOnly -Probe { Test-WidgetEndpoint }
        if ($skip) { Set-ItResult -Skipped -Because $skip; return }
        ...
    }
#>
function Get-TestTargetSkipReason {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string] $Environment,

        [Parameter(Mandatory)]
        [ValidateSet('ReadOnly', 'Synthetic')]
        [string] $Mode,

        [Parameter(Mandatory)]
        [scriptblock] $Probe
    )

    $segment = ($Environment.ToLowerInvariant() -replace '[^a-z0-9]', '')
    Assert-True ($segment -match '^[a-z0-9]+$') -ErrorText "Get-TestTargetSkipReason: environment '$Environment' has no letter or digit to name it by."

    $policyMode = if ($Mode -eq 'Synthetic') {
        'synthetic'
    }
    else {
        'read-only'
    }
    if (-not (Get-Config -Config test-policy).Allows($Environment, $policyMode)) {
        return "target_${segment}_readonly"
    }

    $reachable = try {
        [bool] (& $Probe)
    }
    catch {
        $false
    }
    if (-not $reachable) {
        return "target_${segment}_unreachable"
    }
}
