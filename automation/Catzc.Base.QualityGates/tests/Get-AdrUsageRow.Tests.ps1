Describe 'Get-AdrUsageRow' -Tag 'L0', 'logic', 'ADR-REPO-FILEMETA#14' {
    BeforeAll {
        $script:map = [Catzc.Base.Docs.AdrCitationMap]::new(
            @{ 'ADR-WIDGET-PART' = @{ path = 'docs/adr/widget/part.md'; rules = @(1, 2, 3) } },
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
        Mock Get-Config -ModuleName Catzc.Base.QualityGates -ParameterFilter { $Config -eq 'comments' } {
            $comments = [pscustomobject]@{}
            $comments | Add-Member -MemberType ScriptMethod -Name PageFor -Value { param($Path) $null }
            $comments
        }
    }

    It 'gives one row per rule a Markdown file''s text cites' {
        $rows = @(Get-Rows "# Spec`n`nRests on ADR-WIDGET-PART#1 and ADR-WIDGET-PART#3.`n")
        @($rows.Rule) | Should -Be @(1, 3)
        @($rows.Source | Sort-Object -Unique) | Should -Be @('cites')
    }

    It 'keeps a bare code a code file cites as the whole ADR' {
        $form = [Catzc.Base.CodeMeta.HeadForm]::ForBlock('/*', '*/')
        $rows = @(Get-Rows "// Rests on ADR-WIDGET-PART.`nclass Widget {}`n" 'automation/Catzc.Widget/types/Widget.cs' $form)
        $rows.Count | Should -Be 1
        $rows[0].Rule | Should -BeNullOrEmpty
    }

    It 'reads a link to a rule and a link to the ADR, and skips a link no code owns' {
        $text = "# Spec`n`nSee [the index](../adr/index.md), [the part](../adr/widget/part.md) and [rule 2](../adr/widget/part.md#rule-adr-widget-part2).`n"
        $rows = @(Get-Rows $text)
        $rows.Count | Should -Be 2
        @($rows.Code | Sort-Object -Unique) | Should -Be @('ADR-WIDGET-PART')
        @($rows.Rule) | Should -Be @($null, 2)
        @($rows.Source | Sort-Object -Unique) | Should -Be @('link')
    }

    It 'skips a code or a rule the index does not register' {
        $rows = @(Get-Rows "# Spec`n`nADR-GADGET-SPEC#1, ADR-WIDGET-PART#3 and ADR-WIDGET-PART#9.`n")
        $rows.Count | Should -Be 1
        $rows[0].Rule | Should -Be 3
    }

    It 'reads no code from a head, so a file whose only citation is in its head gives no row' {
        @(Get-Rows "---`ncatzc:`n  edges:`n    cites:`n      - ADR-WIDGET-PART#2`n---`n`n# Spec`n").Count | Should -Be 0
    }
}
