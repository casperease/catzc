<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.QualityGates/tests/Select-RuleTaggedFiles.Tests.ps1
    folder: tests
    name: select-rule-tagged-files-tests
    filetype: ps1
    role: test
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Base.QualityGates
    moduletype: pwsh-folder
    catzc_bundle: azure
  edges:
    docs: "[Select-RuleTaggedFiles.Tests.ps1.md](docs/references/pwsh/catzc-base-qualitygates/tests/Select-RuleTaggedFiles.Tests.ps1.md)"
    cites:
      - ADR-AUTO-TEST-PROVENANCETAGS
---
#>

Describe 'Select-RuleTaggedFiles' -Tag 'L0', 'logic', 'ADR-AUTO-TEST-PROVENANCETAGS' {
    BeforeAll {
        function New-FakeTest {
            param([string] $File, [string[]] $Tags)
            $root = [pscustomobject]@{ IsRoot = $true; Tag = @(); Parent = $null }
            [pscustomobject]@{
                Tag         = @()
                Block       = [pscustomobject]@{ IsRoot = $false; Tag = @($Tags); Parent = $root }
                ScriptBlock = [pscustomobject]@{ File = $File }
            }
        }
        $script:discovery = [pscustomobject]@{
            Tests = @(
                New-FakeTest 'C:\r\a.Tests.ps1' @('L0', 'logic', 'ADR-WIDGET-GADGET-SPIN')
                New-FakeTest 'C:\r\b.Tests.ps1' @('L1', 'logic')
                New-FakeTest 'C:\r\c.Tests.ps1' @('L1', 'logic', 'ADR-WIDGET-GADGET-TURN')
            )
        }
        $script:select = {
            param($Files, $Rule)
            InModuleScope Catzc.Base.QualityGates -Parameters @{ F = $Files; D = $script:discovery; R = $Rule } {
                param($F, $D, $R) Select-RuleTaggedFiles -TestFile $F -Discovery $D -Rule $R
            }
        }
    }

    It 'keeps only the files whose tests cite one of the rules, in input order' {
        $result = & $script:select @('C:\r\a.Tests.ps1', 'C:\r\b.Tests.ps1', 'C:\r\c.Tests.ps1') @('ADR-WIDGET-GADGET-SPIN', 'ADR-WIDGET-GADGET-TURN')
        @($result) | Should -Be @('C:\r\a.Tests.ps1', 'C:\r\c.Tests.ps1')
    }

    It 'returns empty when no test cites the rule' {
        @(& $script:select @('C:\r\a.Tests.ps1', 'C:\r\b.Tests.ps1', 'C:\r\c.Tests.ps1') @('ADR-WIDGET-GADGET-STOP')) | Should -HaveCount 0
    }
}
