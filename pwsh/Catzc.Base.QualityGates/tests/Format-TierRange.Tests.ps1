<#
---
catzc:
  immutable:
    with_body_sha: "56c19ed6028c"
  edges:
    code: pwsh/Catzc.Base.QualityGates/private/Format-TierRange.ps1
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
