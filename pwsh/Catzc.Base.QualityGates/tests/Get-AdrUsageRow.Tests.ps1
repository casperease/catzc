Describe 'Get-AdrUsageRow' -Tag 'L0', 'logic', 'ADR-REPO-FILEMETA-NOREADBACK' {
    BeforeAll {
        $script:map = [Catzc.Base.Docs.AdrCitationMap]::new(
            @{ 'ADR-WIDGET-PART' = @{ path = 'docs/adr/widget/part.md'; rules = [string[]] @('ADR-WIDGET-PART-TURN', 'ADR-WIDGET-PART-SPIN', 'ADR-WIDGET-PART-FOLD') } },
            @('docs/adr/widget/part.md', 'docs/adr/index.md'))

        function script:Get-Rows {
            param([string] $Text, [string] $Path = 'docs/gadget/spec.md', $Form)
            InModuleScope Catzc.Base.QualityGates -Parameters @{ Text = $Text; Path = $Path; Map = $script:map; Form = $Form } {
                param($Text, $Path, $Map, $Form)
                if ($Form) {
                    Get-AdrUsageRow -Text $Text -Path $Path -Map $Map -Form $Form
                }
                else {
                    Get-AdrUsageRow -Text $Text -Path $Path -Map $Map
                }
            }
        }
    }

    BeforeEach {
        Mock Get-AdrCitationMap -ModuleName Catzc.Base.QualityGates { $script:map }
        Mock Get-CommentPage -ModuleName Catzc.Base.QualityGates { }
    }

    It 'gives one row per rule a Markdown file''s text cites, under its ADR' {
        $rows = @(Get-Rows "# Spec`n`nRests on ADR-WIDGET-PART-TURN and ADR-WIDGET-PART-FOLD.`n")
        @($rows.Rule) | Should -Be @('ADR-WIDGET-PART-TURN', 'ADR-WIDGET-PART-FOLD')
        @($rows.Code | Sort-Object -Unique) | Should -Be @('ADR-WIDGET-PART')
        @($rows.Source | Sort-Object -Unique) | Should -Be @('cites')
    }

    It 'keeps an ADR code a code file cites as the whole ADR' {
        $form = [Catzc.Base.CodeMeta.HeadForm]::ForBlock('/*', '*/')
        $rows = @(Get-Rows "// Rests on ADR-WIDGET-PART.`nclass Widget {}`n" "$(Get-CatzcModulesFolder)/Catzc.Widget/types/Widget.cs" $form)
        $rows.Count | Should -Be 1
        $rows[0].Rule | Should -BeNullOrEmpty
    }

    It 'reads a link to a rule and a link to the ADR, and skips a link no code owns' {
        $text = "# Spec`n`nSee [the index](../adr/index.md), [the part](../adr/widget/part.md) and [a rule](../adr/widget/part.md#rule-adr-widget-part-spin).`n"
        $rows = @(Get-Rows $text)
        $rows.Count | Should -Be 2
        @($rows.Code | Sort-Object -Unique) | Should -Be @('ADR-WIDGET-PART')
        @($rows.Rule) | Should -Be @($null, 'ADR-WIDGET-PART-SPIN')
        @($rows.Source | Sort-Object -Unique) | Should -Be @('link')
    }

    It 'skips a code or a rule the index does not register' {
        $rows = @(Get-Rows "# Spec`n`nADR-GADGET-SPEC-TURN, ADR-WIDGET-PART-FOLD and ADR-WIDGET-PART-SINK.`n")
        $rows.Count | Should -Be 1
        $rows[0].Rule | Should -Be 'ADR-WIDGET-PART-FOLD'
    }

    It 'reads no code from a head, so a file whose only citation is in its head gives no row' {
        @(Get-Rows "---`ncatzc:`n  edges:`n    cites:`n      - ADR-WIDGET-PART-SPIN`n---`n`n# Spec`n").Count | Should -Be 0
    }
}
