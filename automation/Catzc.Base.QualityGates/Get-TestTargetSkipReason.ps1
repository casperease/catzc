<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/Get-TestTargetSkipReason.ps1
    kind: automation-function
    module: Catzc.Base.QualityGates
    visibility: public
    relatives:
      test: automation/Catzc.Base.QualityGates/tests/Get-TestTargetSkipReason.Tests.ps1
    adrs:
      - ADR-AUTO-TEST#{8,41}
  config:
    synopsis: Says why an L4 test must skip against its target environment, or nothing when it may run.
    description: |-
      An L4 test checks the released system itself, after final approval
      ([ADR-AUTO-TEST#41](/docs/adr/automation/test-automation.md#rule-adr-auto-test41)). It may run anywhere, a devbox
      included: the only limit is the security context of the console running it. So each L4 test asks here first
      and self-skips with the answer ([ADR-AUTO-TEST#8](/docs/adr/automation/test-automation.md#rule-adr-auto-test8)):
        - target_<environment>_unreachable — the probe says this console's identity cannot reach the environment
          (or the probe throws);
        - target_<environment>_readonly    — the test needs synthetic transactions, but test-policy.yml lets the
          environment take read-only probes only (the default for an environment it does not list).
      The answer is a constrained skip key: the environment name is lowercased with every character but a letter or
      digit dropped (pre-prod -> preprod). A console run of L4 tests is a run of that gate outside its pipeline:
      information, never a gate verdict.
    parameters:
      Environment: The target environment the test reaches, e.g. pre-prod or production.
      Mode: |-
        How far the test changes the target: ReadOnly (probes and observations) or Synthetic (transactions the
        system accepts and cleans up).
      Probe: |-
        Answers whether this console's identity can reach the environment: a script block returning $true when it
        can. A probe that throws counts as unreachable.
    outputs: '[string] the skip key, or nothing when the test may run.'
    examples:
      - |-
        It 'answers on its health endpoint' -Tag 'L4', 'integrity' {
            $skip = Get-TestTargetSkipReason -Environment production -Mode ReadOnly -Probe { Test-WidgetEndpoint }
            if ($skip) { Set-ItResult -Skipped -Because $skip; return }
            ...
        }
---
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
