<#
---
catzc:
  immutable:
    path: automation/Catzc.Base.QualityGates/tests/Get-AdrDefinedRule.Tests.ps1
    folder: tests
    name: get-adr-defined-rule-tests
    filetype: ps1
    kind: test
    language: powershell
    track: automation
    module: Catzc.Base.QualityGates
    moduletype: pwsh-folder
    catzc_bundle: azure
  edges:
    cites:
      - ADR-REPO-LINK#5
---
#>

Describe 'Get-AdrDefinedRule' -Tag 'L0', 'logic', 'ADR-REPO-LINK#5' {
    BeforeAll {
        function script:Get-Defined {
            param([string] $Text)
            $rules = InModuleScope Catzc.Base.QualityGates -Parameters @{ Text = $Text } {
                param($Text)
                Get-AdrDefinedRule -Text $Text
            }
            , @($rules)
        }
    }

    It 'spells each rule heading as a citation, in document order' {
        $text = "## Rules: ADR-WIDGET`n`n### Rule ADR-WIDGET:1`n`nText.`n`n### Rule ADR-WIDGET:2`n`n### Rule ADR-WIDGET:10`n"
        (Get-Defined $text) | Should -Be @('ADR-WIDGET#1', 'ADR-WIDGET#2', 'ADR-WIDGET#10')
    }

    It 'reads a code of several segments' {
        Get-Defined "### Rule ADR-GADGET-PART:3`n" | Should -Be @('ADR-GADGET-PART#3')
    }

    It 'lists a rule once when its heading repeats' {
        Get-Defined "### Rule ADR-WIDGET:1`n`n### Rule ADR-WIDGET:1`n" | Should -Be @('ADR-WIDGET#1')
    }

    It 'takes a citation in prose, a registry heading and a deeper heading for no definition' {
        # The colon forms are built from two strings: a literal one would be respelled to the hash form by the string-citation alignment.
        $text = "## Rules: ADR-WIDGET`n`nSee ADR-WIDGET#1 and ADR-WIDGET" + ":2.`n`n#### Rule ADR-WIDGET" + ":3`n"
        (Get-Defined $text).Count | Should -Be 0
    }

    It 'returns an empty list for an empty text' {
        (Get-Defined '').Count | Should -Be 0
    }
}
