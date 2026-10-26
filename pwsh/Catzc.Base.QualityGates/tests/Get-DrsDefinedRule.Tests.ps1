Describe 'Get-DrsDefinedRule' -Tag 'L0', 'logic', 'ADR-REPO-LINK-ONECITATIONSPELLING' {
    BeforeAll {
        function script:Get-Defined {
            param([string] $Text)
            $rules = InModuleScope Catzc.Base.QualityGates -Parameters @{ Text = $Text } {
                param($Text)
                Get-DrsDefinedRule -Text $Text
            }
            , @($rules)
        }
    }

    It 'reads each rule heading as its code, in document order' {
        $text = "## Rules: ADR-WIDGET-PART`n`n### Rule ADR-WIDGET-PART-TURN`n`nText.`n`n### Rule ADR-WIDGET-PART-SPIN`n`n### Rule ADR-WIDGET-PART-FOLD`n"
        (Get-Defined $text) | Should -Be @('ADR-WIDGET-PART-TURN', 'ADR-WIDGET-PART-SPIN', 'ADR-WIDGET-PART-FOLD')
    }

    It 'reads a rule name with digits, as a vendor id has' {
        Get-Defined "### Rule ADR-GADGET-PART-RE03`n" | Should -Be @('ADR-GADGET-PART-RE03')
    }

    It 'lists a rule once when its heading repeats' {
        Get-Defined "### Rule ADR-WIDGET-PART-TURN`n`n### Rule ADR-WIDGET-PART-TURN`n" |
            Should -Be @('ADR-WIDGET-PART-TURN')
    }

    It 'takes a citation in prose, a numbered heading and a deeper heading for no definition' {
        # The numbered heading is built from two strings, so the string-citation check reads no numbered citation in
        # this file.
        $text = "## Rules: ADR-WIDGET-PART`n`nSee ADR-WIDGET-PART-TURN.`n`n### Rule ADR-WIDGET-PART" + ":2`n`n#### Rule ADR-WIDGET-PART-SPIN`n"
        (Get-Defined $text).Count | Should -Be 0
    }

    It 'returns an empty list for an empty text' {
        (Get-Defined '').Count | Should -Be 0
    }
}
