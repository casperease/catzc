# Get-LinkEdge -To answers what points at a file, written or derived: the blast radius of changing it.
Describe 'Get-LinkEdge' -Tag 'L0', 'logic', 'ADR-REPO-LINKS-CONVENTIONSAREDERIVED', 'ADR-REPO-LINKS-CHECKEDBYONEGATE' {
    BeforeEach {
        InModuleScope Catzc.Base.QualityGates {
            $edge = { param([string] $From, [string] $Target,
                    [string] $Relation) [Catzc.Base.QualityGates.LinkEdge]::new($From, 1, 1, $Relation, $Target, '') }
            Mock Assert-SourceTree { }
            Mock Get-LinkScope { @('mods/Widget/Get-Widget.ps1') }
            Mock Invoke-LinkEngine {
                $result = [pscustomobject] @{ Edges = @(
                        (& $edge 'docs/widget.md' 'mods/Widget/Get-Widget.ps1' 'MarkdownLink')
                        (& $edge 'docs/gadget.md' 'mods/Gadget/Get-Gadget.ps1' 'MarkdownLink')
                    )
                }
                $result
            }.GetNewClosure()
            Mock Get-ConventionEdge {
                (& $edge 'mods/Widget/tests/Get-Widget.Tests.ps1' 'mods/Widget/Get-Widget.ps1' 'Convention')
                (& $edge 'mods/Gizmo' 'mods/Widget' 'Convention')
            }.GetNewClosure()
        }
        $script:into = {
            param([string] $To)
            InModuleScope Catzc.Base.QualityGates -Parameters @{ To = $To } { param($To) @(Get-LinkEdge -To $To -RepositoryRoot $TestDrive) }
        }
    }

    It 'returns every relation into a file, written and derived, and none into another file' {
        @((& $into 'mods/Widget/Get-Widget.ps1') | ForEach-Object { "$($_.Relation) $($_.File)" }) | Should -Be @(
            'MarkdownLink docs/widget.md'
            'Convention mods/Widget/tests/Get-Widget.Tests.ps1'
        )
    }

    It 'takes a folder as everything under it, so a module''s dependents are among a file''s blast radius' {
        @((& $into 'mods/Widget') | ForEach-Object { $_.File }) | Should -Be @('docs/widget.md',
            'mods/Widget/tests/Get-Widget.Tests.ps1', 'mods/Gizmo')
        @(& $into 'mods/Wid') | Should -HaveCount 0 -Because 'a path prefix is no folder'
    }

    It 'spells the target either way and returns nothing for a file no relation names' {
        @(& $into 'mods\Widget\Get-Widget.ps1') | Should -HaveCount 2
        @(& $into 'mods/Sprocket.ps1') | Should -HaveCount 0
    }
}
