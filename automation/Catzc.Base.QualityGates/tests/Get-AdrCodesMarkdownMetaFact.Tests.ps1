Describe 'Get-AdrCodesMarkdownMetaFact' -Tag 'L0', 'logic', 'ADR-REPO-FILEMETA#3' {
    BeforeAll {
        $script:kind = [Catzc.Base.QualityGates.MarkdownMetaConfig]::new(@{ kinds = [ordered]@{ 'adr-codes' = @{ keys = @('adrs') } } }).kinds[0]

        function script:Get-Codes {
            param([string] $Body)
            $state = Get-MarkdownMetaState -Text $Body
            $fact = InModuleScope Catzc.Base.QualityGates -Parameters @{ State = $state; Kind = $script:kind } {
                param($State, $Kind)
                Get-AdrCodesMarkdownMetaFact -State $State -Path 'docs/widget.md' -Kind $Kind
            }
            , @($fact['adrs'])
        }
    }

    It 'lists each cited rule once, sorted by ordinal order' {
        $codes = Get-Codes "# docs/widget.md`n`nSee ADR-WIDGET-PART#3 and ADR-GADGET#12, then ADR-WIDGET-PART#3 again, and ADR-GADGET#2.`n"
        $codes | Should -Be @('ADR-GADGET#12', 'ADR-GADGET#2', 'ADR-WIDGET-PART#3')
    }

    It 'ignores the colon form a rule heading uses and a code with no rule number' {
        $codes = Get-Codes "### Rule ADR-WIDGET:1`n`nThe ADR-WIDGET decision.`n"
        $codes.Count | Should -Be 0
    }

    It 'finds a citation inside a link' {
        $codes = Get-Codes "[ADR-GADGET#4](/docs/adr/gadget.md#rule-adr-gadget4)`n"
        $codes | Should -Be @('ADR-GADGET#4')
    }

    It 'returns an empty list for a file that cites nothing' {
        (Get-Codes "# docs/widget.md`n").Count | Should -Be 0
    }

    It 'does not read a citation from the front matter' {
        $codes = Get-Codes "---`ncatzc:`n  derived:`n    adrs:`n      - ADR-WIDGET#9`n---`nbody`n"
        $codes.Count | Should -Be 0
    }
}
