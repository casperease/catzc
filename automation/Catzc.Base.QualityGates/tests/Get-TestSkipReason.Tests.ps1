<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/tests/Get-TestSkipReason.Tests.ps1
    kind: pester-test
    relatives:
      page: docs/references/automation/catzc-base-qualitygates/tests/Get-TestSkipReason.Tests.ps1.md
      source: automation/Catzc.Base.QualityGates/private/Get-TestSkipReason.ps1
---
#>

Describe 'Get-TestSkipReason' -Tag 'L0', 'logic' {
    BeforeAll {
        function New-FakeSkip {
            param([string] $Message, [switch] $NoRecord)
            $records = if ($NoRecord) {
                @()
            }
            else {
                @([pscustomobject]@{ Exception = [pscustomobject]@{ Message = $Message } })
            }
            [pscustomobject]@{ ErrorRecord = $records }
        }
    }

    It 'returns the -Because reason from a Set-ItResult skip' {
        $test = New-FakeSkip -Message 'is skipped, because az not installed'
        InModuleScope Catzc.Base.QualityGates -Parameters @{ T = $test } {
            param($T)
            Get-TestSkipReason -Test $T | Should -Be 'az not installed'
        }
    }

    It 'reports no reason for a bare skip with no -Because' {
        $test = New-FakeSkip -Message 'is skipped'
        InModuleScope Catzc.Base.QualityGates -Parameters @{ T = $test } {
            param($T)
            Get-TestSkipReason -Test $T | Should -Be 'no reason given'
        }
    }

    It 'reports no reason for an It -Skip that records nothing' {
        $test = New-FakeSkip -NoRecord
        InModuleScope Catzc.Base.QualityGates -Parameters @{ T = $test } {
            param($T)
            Get-TestSkipReason -Test $T | Should -Be 'no reason given'
        }
    }

    It 'returns a non-because framework skip message verbatim' {
        $test = New-FakeSkip -Message "Skipped due to previous failure at 'Mod.Earlier test'"
        InModuleScope Catzc.Base.QualityGates -Parameters @{ T = $test } {
            param($T)
            Get-TestSkipReason -Test $T | Should -Be "Skipped due to previous failure at 'Mod.Earlier test'"
        }
    }
}
