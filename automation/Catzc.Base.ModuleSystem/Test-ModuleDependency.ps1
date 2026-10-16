<#
---
catzc:
  derived:
    path: automation/Catzc.Base.ModuleSystem/Test-ModuleDependency.ps1
    kind: function
    subkind: gate
    language: powershell
    filetype: ps1
    track: automation
    module: Catzc.Base.ModuleSystem
    moduletype: pwsh-folder-module
    bundle: azure
    visibility: public
    relatives:
      test: automation/Catzc.Base.ModuleSystem/tests/Test-ModuleDependency.Tests.ps1
    adrs:
      - ADR-AUTO-TEST#35
  config:
    synopsis: 'Quality gate: checks that the actual module dependencies conform to the declared graph.'
    description: |-
      Compares the real module-to-module edges — PowerShell function calls and cross-module C# type
      references — against the allow-list declared in configs/dependencies.yml (see
      Get-ModuleDependencyViolations for the rules), collects every violation, and ends with
      Write-QualityGateReport ([ADR-AUTO-TEST#35](/docs/adr/automation/test-automation.md#rule-adr-auto-test35)):
      the report lands in out/test-module-dependency/, and the gate throws once listing every violation (or
      returns the result with -PassThru).

      A structurally invalid config throws at load time (via Get-ModuleDependencyConfig) before any
      conformance check runs — a malformed config is a bug to fix, not a conformance result.

      Must run post-import so the actual call graph covers all loaded modules.
    parameters:
      OutputFolder: The report base folder. Defaults to Write-QualityGateReport's (out/test-module-dependency).
      PassThru: Return the gate result { Subject; IssueCount; Issues; ReportPath } instead of throwing on violations.
    outputs: '[pscustomobject] With -PassThru only.'
    examples:
      - Test-ModuleDependency
      - (Test-ModuleDependency -PassThru).Issues
---
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
