<#
---
catzc:
  immutable:
    path: automation/Catzc.Base.QualityGates/tests/Format-TierRange.Tests.ps1
    folder: tests
    name: format-tier-range-tests
    filetype: ps1
    kind: test
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.QualityGates
    moduletype: pwsh-folder
    catzc_bundle: azure
---
#>

# The tier-range label a test run prints on its banner and in its context block.
Describe 'Format-TierRange' -Tag 'L0', 'logic' {
    It 'names one tier alone and a range with both ends' {
        InModuleScope Catzc.Base.QualityGates {
            Format-TierRange -MinLevel 2 -MaxLevel 2 | Should -Be 'L2'
            Format-TierRange -MinLevel 0 -MaxLevel 3 | Should -Be 'L0-L3'
        }
    }
}
