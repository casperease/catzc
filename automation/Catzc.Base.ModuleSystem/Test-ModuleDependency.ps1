<#
.SYNOPSIS
    Quality gate: checks that the actual module dependencies conform to the declared graph.
.DESCRIPTION
    Compares the real module-to-module edges — PowerShell function calls and cross-module C# type
    references — against the allow-list declared in configs/dependencies.yml (see
    Get-ModuleDependencyViolations for the rules), collects every violation, and ends with
    Write-QualityGateReport ([ADR-AUTO-TEST#35](/docs/adr/automation/test-automation.md#rule-adr-auto-test35)):
    the report lands in out/test-module-dependency/, and the gate throws once listing every violation (or
    returns the result with -PassThru).

    A structurally invalid config throws at load time (via Get-ModuleDependencyConfig) before any
    conformance check runs — a malformed config is a bug to fix, not a conformance result.

    Must run post-import so the actual call graph covers all loaded modules.
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
