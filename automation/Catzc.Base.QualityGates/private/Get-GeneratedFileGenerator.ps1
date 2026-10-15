<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/private/Get-GeneratedFileGenerator.ps1
    kind: private-function
    module: Catzc.Base.QualityGates
    visibility: private
    adrs:
      - ADR-AUTO-TEST#35
---
#>

<#
.SYNOPSIS
    Lists every generator Test-GeneratedFiles can check: the registered writers, then the generators of the managed root files.
.DESCRIPTION
    A root-file generator is named by an opted-in entry of the root-config registry, so it is listed once, in registry
    order ([ADR-AUTO-TEST#35](/docs/adr/automation/test-automation.md#rule-adr-auto-test35)).
.OUTPUTS
    [string[]] The writer names of generated-files.yml, then the distinct generator names of rootconfig.yml.
#>
function Get-GeneratedFileGenerator {
    [CmdletBinding()]
    [OutputType([string[]])]
    param()

    $writers = @((Get-Config -Config generated-files).writers.Keys)
    $rootGenerators = @((Get-Config -Config rootconfig).files | Where-Object { $_.optIn -and $_.generator } | ForEach-Object { "$($_.generator)" } | Select-Object -Unique)
    [string[]] @($writers + $rootGenerators)
}
