<#
---
catzc:
  immutable:
    with_body_sha: "3e827ea01d87"
  edges:
    code: pwsh/Catzc.Base.QualityGates/private/Assert-TestTagGate.ps1
    cites:
      - ADR-AUTO-TEST-TAGSENFORCED
---
#>

Describe 'Assert-TestTagGate' -Tag 'L0', 'logic', 'ADR-AUTO-TEST-TAGSENFORCED' {
    BeforeEach {
        Mock Write-Message -ModuleName Catzc.Base.QualityGates { }
    }

    It 'is silent when no test violates a mandatory tag axis' {
        Mock Get-TestTagViolations -ModuleName Catzc.Base.QualityGates { , @() }

        { InModuleScope Catzc.Base.QualityGates { Assert-TestTagGate -Discovery ([pscustomobject]@{ Tests = @() }) } } |
            Should -Not -Throw
        Should -Invoke Write-Message -ModuleName Catzc.Base.QualityGates -Times 0
    }

    It 'lists every violation, then throws with the count' {
        Mock Get-TestTagViolations -ModuleName Catzc.Base.QualityGates {
            , @(
                [pscustomobject]@{ Test = 'Widget.untagged'; Reason = 'tier resolves to 0' }
                [pscustomobject]@{ Test = 'Gadget.untagged'; Reason = 'category resolves to 0' }
            )
        }

        { InModuleScope Catzc.Base.QualityGates { Assert-TestTagGate -Discovery ([pscustomobject]@{ Tests = @() }) } } |
            Should -Throw '2 test(s) are missing a required tier/category tag*'
        Should -Invoke Write-Message -ModuleName Catzc.Base.QualityGates -Times 1 -ParameterFilter { $Message -like '*Widget.untagged*' }
        Should -Invoke Write-Message -ModuleName Catzc.Base.QualityGates -Times 1 -ParameterFilter { $Message -like '*Gadget.untagged*' }
    }
}
