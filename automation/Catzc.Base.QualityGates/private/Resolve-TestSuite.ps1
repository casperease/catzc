<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/private/Resolve-TestSuite.ps1
    kind: automation-function
    module: Catzc.Base.QualityGates
    visibility: private
    adrs:
      - ADR-AUTO-TEST#37
      - ADR-FLOW-CD-GLOBS#7
  config:
    synopsis: |-
      Resolves a named test suite — a globset's declared verify scope (globs.yml `verify:`) — into Test-Automation's run
      parameters.
    description: |-
      The -Suite resolver. A test suite is a named, declared selection of tests
      ([ADR-AUTO-TEST#37](/docs/adr/automation/test-automation.md#rule-adr-auto-test37)): a globset's `verify:` scope, the
      modules whose tests verify a change in that area-of-control and the tier to run them through (the blast-radius marker
      role, [ADR-FLOW-CD-GLOBS#7](/docs/adr/flow/durable-sha-globs.md#rule-adr-flow-cd-globs7)). This looks the named globset
      up in the registry (an unknown name throws there, naming the config) and returns that scope. A globset without a
      verify scope is not a test suite; it throws with the remedy: declare one in globs.yml.
    parameters:
      Name: The name of a test suite — its globset's name (globs.yml).
    outputs: '[pscustomobject] with Modules (string[]) and Level (int 0-3).'
---
#>

function Resolve-TestSuite {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Mandatory)]
        [string] $Name
    )

    $set = Get-GlobSet -Name $Name
    if ($set.VerifyModules.Count -eq 0) {
        throw "Globset '$Name' declares no verify scope, so it is not a test suite — add 'verify: { modules: [...], level: N }' to it in globs.yml to run it with -Suite (ADR-AUTO-TEST#37)."
    }

    [pscustomobject]@{
        Modules = @($set.VerifyModules)
        Level   = $set.VerifyLevel
    }
}
