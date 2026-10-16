<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/tests/Get-TestExcludeTag.Tests.ps1
    kind: test
    language: powershell
    filetype: ps1
    track: automation
    module: Catzc.Base.QualityGates
    moduletype: pwsh-folder-module
    bundle: azure
    relatives:
      page: docs/references/automation/catzc-base-qualitygates/tests/Get-TestExcludeTag.Tests.ps1.md
    adrs:
      - ADR-AUTO-TEST#41
---
#>

Describe 'Get-TestExcludeTag' -Tag 'L0', 'logic' {
    It 'a Logic L0/L1 run excludes the higher tiers and integrity' {
        InModuleScope Catzc.Base.QualityGates {
            $tags = Get-TestExcludeTag -MinLevel 0 -MaxLevel 1 -Category Logic
            $tags | Should -Contain 'L2'
            $tags | Should -Contain 'L3'
            $tags | Should -Contain 'integrity'
            $tags | Should -Not -Contain 'L0'
            $tags | Should -Not -Contain 'logic'
        }
    }

    It 'an Integrity run excludes logic' {
        InModuleScope Catzc.Base.QualityGates {
            Get-TestExcludeTag -Category Integrity | Should -Contain 'logic'
        }
    }

    It 'a Both run through L3, the default top tier, excludes only the opt-in L4' -Tag 'ADR-AUTO-TEST#41' {
        InModuleScope Catzc.Base.QualityGates {
            Get-TestExcludeTag -MinLevel 0 -MaxLevel 3 -Category Both | Should -Be @('L4')
        }
    }

    It 'a Both run through L4 excludes nothing' {
        InModuleScope Catzc.Base.QualityGates {
            @(Get-TestExcludeTag -MinLevel 0 -MaxLevel 4 -Category Both).Count | Should -Be 0
        }
    }

    It 'an L4-only run excludes every lower tier' {
        InModuleScope Catzc.Base.QualityGates {
            Get-TestExcludeTag -MinLevel 4 -MaxLevel 4 | Should -Be @('L0', 'L1', 'L2', 'L3')
        }
    }

    It 'a MinLevel-2 run excludes the lower tiers' {
        InModuleScope Catzc.Base.QualityGates {
            $tags = Get-TestExcludeTag -MinLevel 2 -MaxLevel 2
            $tags | Should -Contain 'L0'
            $tags | Should -Contain 'L1'
            $tags | Should -Not -Contain 'L2'
        }
    }
}
