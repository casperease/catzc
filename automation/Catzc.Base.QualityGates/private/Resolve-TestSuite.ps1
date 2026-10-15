# catzc:
#   path: automation/Catzc.Base.QualityGates/private/Resolve-TestSuite.ps1
#   module: Catzc.Base.QualityGates
#   visibility: private

<#
.SYNOPSIS
    Resolves a named test suite — a globset's declared verify scope (globs.yml `verify:`) — into Test-Automation's run
    parameters.
.DESCRIPTION
    A globset without a verify scope is not a test suite, so it throws and tells you to declare one in globs.yml.
    [ADR-AUTO-TEST#37](/docs/adr/automation/test-automation.md#rule-adr-auto-test37),
    [ADR-FLOW-CD-GLOBS#7](/docs/adr/flow/durable-sha-globs.md#rule-adr-flow-cd-globs7)
    [comment:1](/docs/references/automation/catzc-base-qualitygates/private/Resolve-TestSuite.ps1.md#comment1)
.PARAMETER Name
    The name of a test suite — its globset's name (globs.yml).
.OUTPUTS
    [pscustomobject] with Modules (string[]) and Level (int 0-3).
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
