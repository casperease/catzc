# catzc:
#   path: automation/Catzc.Base.ModuleSystem/Test-ModuleDependency.ps1
#   module: Catzc.Base.ModuleSystem
#   visibility: public

<#
.SYNOPSIS
    Quality gate: checks that the actual module dependencies conform to the declared graph.
.DESCRIPTION
    A malformed config throws at load, before any check runs: it is a bug to fix, not a conformance result.
    [ADR-AUTO-TEST#35](/docs/adr/automation/test-automation.md#rule-adr-auto-test35)
    [comment:1](/docs/references/automation/catzc-base-modulesystem/Test-ModuleDependency.ps1.md#comment1)
.PARAMETER OutputFolder
    The report base folder. Defaults to Write-QualityGateReport's (out/test-module-dependency).
.PARAMETER PassThru
    Return the gate result { Subject; IssueCount; Issues; ReportPath } instead of throwing on violations.
.OUTPUTS
    [pscustomobject] With -PassThru only.
.EXAMPLE
    Test-ModuleDependency
.EXAMPLE
    (Test-ModuleDependency -PassThru).Issues
#>
function Test-ModuleDependency {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [string] $OutputFolder,

        [switch] $PassThru
    )

    Write-QualityGateReport -Subject module-dependency -Title Test-ModuleDependency `
        -Issues @(Get-ModuleDependencyViolations) -OutputFolder $OutputFolder -PassThru:$PassThru
}
