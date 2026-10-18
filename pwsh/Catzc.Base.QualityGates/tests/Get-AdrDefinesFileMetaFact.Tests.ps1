Describe 'Get-AdrDefinesFileMetaFact' -Tag 'L0', 'logic', 'ADR-REPO-FILEMETA-IMPRINTEDPARTS' {
    BeforeAll {
        $script:kind = [Catzc.Base.QualityGates.FileMetaConfig]::new(@{ kinds = [ordered]@{ 'adr-defines' = @{ keys = @('defines') } } }).kinds[0]

        function script:Get-Defines {
            param([string] $Body)
            $state = Get-MarkdownMetaState -Text $Body
            InModuleScope Catzc.Base.QualityGates -Parameters @{ State = $state; Kind = $script:kind } {
                param($State, $Kind)
                Get-AdrDefinesFileMetaFact -State $State -Path 'docs/adr/widget.md' -Kind $Kind
            }
        }
    }

    It 'lists the rules the file defines under the kind''s key' {
        $fact = Get-Defines "# ADR: Widget`n`n## Rules: ADR-WIDGET-PART`n`n### Rule ADR-WIDGET-PART-TURN`n`n### Rule ADR-WIDGET-PART-SPIN`n"
        @($fact.Keys) | Should -Be @('defines')
        @($fact['defines']) | Should -Be @('ADR-WIDGET-PART-TURN', 'ADR-WIDGET-PART-SPIN')
    }

    It 'keeps the authored order of the headings, never a sorted one' {
        $fact = Get-Defines "# ADR: Widget`n`n### Rule ADR-WIDGET-PART-SPIN`n`n### Rule ADR-WIDGET-PART-FOLD`n`n### Rule ADR-WIDGET-PART-BEND`n"
        @($fact['defines']) | Should -Be @('ADR-WIDGET-PART-SPIN', 'ADR-WIDGET-PART-FOLD', 'ADR-WIDGET-PART-BEND')
    }

    It 'keeps a single defined rule as it is' {
        $fact = Get-Defines "# ADR: Widget`n`n### Rule ADR-WIDGET-PART-TURN`n"
        @($fact['defines']) | Should -Be @('ADR-WIDGET-PART-TURN')
    }

    It 'lists no rule for a file that defines none, however many it cites' {
        $fact = Get-Defines "# ADR: Index`n`nSee ADR-GADGET-PART-DROP.`n"
        @($fact['defines']).Count | Should -Be 0
    }

    It 'does not read a heading from the front matter' {
        $fact = Get-Defines "---`ncatzc:`n  edges:`n    defines:`n      - ADR-WIDGET-PART-SPIN`n---`nbody`n"
        @($fact['defines']).Count | Should -Be 0
    }
}
