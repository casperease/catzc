<#
---
catzc:
  docs: "../../../../docs/references/pwsh/catzc-base-quality-gates/tests/types/LinkDirectionEngine.Tests.ps1.md"
  warning: "Generated Header"
---
#>

Describe 'LinkDirectionEngine' -Tag 'L0', 'logic', 'ADR-REPO-LINKS-DIRECTIONSAREROWS', 'ADR-REPO-LINKS-EXCEPTIONSAREENTRIES' {
    BeforeAll {
        $script:endpoints = [System.Collections.Generic.Dictionary[string, Catzc.Base.QualityGates.LinkEndpoint]]::new()
        foreach ($pair in @(('mods/Widget/Get-Widget.ps1', 'code'), ('docs/drs/widget.md', 'adr'), ('docs/how-to/gadget.md', 'how-to'))) {
            $endpoints[$pair[0]] = [Catzc.Base.QualityGates.LinkEndpoint]::new($pair[0], $pair[1], '', '', '', '')
        }
        $script:edge = {
            param([string] $File, [string] $Target, [string] $Relation = 'CodeLink')
            [Catzc.Base.QualityGates.LinkEdge]::new($File, 4, 2, $Relation, $Target, '')
        }
        $script:config = {
            param([hashtable] $Exempt = @{})
            [Catzc.Base.QualityGates.LinkDirectionsConfig]::new([ordered]@{
                    rows   = @(
                        @{ relations = @('code_link'); from = @{ classes = @('code') }; to = @{ classes = @('adr') }; verdict = 'allow'; because = 'ADR-WIDGET-ONE' }
                        @{ relations = @('code_link'); verdict = 'deny'; because = 'ADR-WIDGET-ONEWAY' }
                        @{ relations = @('code_link'); verdict = 'allow'; because = 'ADR-WIDGET-NEVER' }
                    )
                    exempt = $Exempt
                })
        }
        $script:judge = { param([object[]] $Edges, $Config = (& $script:config)) @([Catzc.Base.QualityGates.LinkDirectionEngine]::Judge([Catzc.Base.QualityGates.LinkEdge[]] $Edges, $script:endpoints, $Config)) }
    }

    It 'lets the first matching row decide: an allowed relation is no finding, a denied one names its row and rule' {
        @(& $judge @(& $edge 'mods/Widget/Get-Widget.ps1' 'docs/drs/widget.md')) | Should -HaveCount 0
        $findings = & $judge @(& $edge 'mods/Widget/Get-Widget.ps1' 'docs/how-to/gadget.md')
        $findings | Should -HaveCount 1
        $findings[0].Row | Should -Be 2 -Because 'the deny row comes before the later allow row'
        "$($findings[0])" | Should -Be 'mods/Widget/Get-Widget.ps1:4 [CodeLink] code -> how-to denied by row 2: ADR-WIDGET-ONEWAY'
    }

    It 'denies a relation no row allows' {
        $findings = & $judge @(& $edge 'docs/how-to/gadget.md' 'docs/drs/widget.md' 'MarkdownLink')
        "$($findings[0])" | Should -Be 'docs/how-to/gadget.md:4 [MarkdownLink] how-to -> adr no row allows it'
    }

    It 'skips an exempt file' {
        @(& $judge @(& $edge 'mods/Widget/Get-Widget.ps1' 'docs/how-to/gadget.md') (& $config @{ 'mods/Widget/Get-Widget.ps1' = 'a fixture' })) | Should -HaveCount 0
    }

    It 'reports an edge whose end has no endpoint, never skips it' {
        $findings = & $judge @(& $edge 'mods/Widget/Get-Widget.ps1' 'docs/gadget/gone.md')
        "$($findings[0])" | Should -BeLike '*has no endpoint for docs/gadget/gone.md'
    }
}
