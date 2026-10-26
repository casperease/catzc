Describe 'Get-ConventionEdge' -Tag 'L0', 'logic', 'ADR-REPO-LINKS-CONVENTIONSAREDERIVED' {
    BeforeEach {
        InModuleScope Catzc.Base.QualityGates {
            # A comment-pages config whose one plain map puts a module file's page under docs/references, path for path.
            $pages = [Catzc.Base.CodeMeta.CommentPagesConfig]::new(@{ pages = @(@{ source = 'mods'; docs = 'docs/references/mods' }) })
            Mock Get-Config -ParameterFilter { $Config -eq 'comment-pages' } { $pages }.GetNewClosure()
            Mock Get-CatzcModulesFolder { 'mods' }
            Mock Get-ModuleDependencyEdges {
                [pscustomobject] @{ From = 'Widget'; To = 'Gadget' }
                [pscustomobject] @{ From = 'Widget'; To = 'Toolbox' }
            }
        }
        $script:derive = {
            param([string[]] $Files)
            InModuleScope Catzc.Base.QualityGates -Parameters @{ Files = $Files } { param($Files) Get-ConventionEdge -Path $Files }
        }
        $script:shown = { param($Edges) @($Edges | ForEach-Object { "$($_.File) -> $($_.Target)" }) }
    }

    It 'points a test at the file of its own unit with its stem, a typed test included' {
        $edges = & $derive @('mods/Widget/Get-Widget.ps1', 'mods/Widget/types/Cog.cs', 'mods/Gadget/Get-Widget.ps1',
            'mods/Widget/tests/Get-Widget.Tests.ps1', 'mods/Widget/tests/types/Cog.Tests.ps1',
            'mods/Widget/tests/Get-Sprocket.Tests.ps1')
        @(& $shown $edges.Where({ $_.File -like '*/tests/*' })) | Should -Be @(
            'mods/Widget/tests/Get-Widget.Tests.ps1 -> mods/Widget/Get-Widget.ps1'
            'mods/Widget/tests/types/Cog.Tests.ps1 -> mods/Widget/types/Cog.cs'
        ) -Because 'the other unit''s file of the same name is not its subject, and a test with no subject has no relation'
    }

    It 'points a file at its comment page only when the page is tracked' {
        $edges = & $derive @('mods/Widget/Get-Widget.ps1', 'docs/references/mods/widget/get-widget.md',
            'mods/Widget/Get-Gizmo.ps1')
        @(& $shown $edges.Where({ $_.Target -like 'docs/*' })) |
            Should -Be @('mods/Widget/Get-Widget.ps1 -> docs/references/mods/widget/get-widget.md')
    }

    It 'points a module at each declared dependency that is a module, and no other' {
        $edges = & $derive @('mods/Widget/Get-Widget.ps1', 'mods/Gadget/Get-Gadget.ps1')
        @(& $shown $edges.Where({ $_.File -eq 'mods/Widget' })) |
            Should -Be @('mods/Widget -> mods/Gadget') -Because 'Toolbox has no folder: a group name, no module'
    }

    It 'marks every edge as a convention relation with no line of its own' {
        $edges = & $derive @('mods/Widget/Get-Widget.ps1', 'mods/Widget/tests/Get-Widget.Tests.ps1')
        @($edges.Relation | Select-Object -Unique) | Should -Be @([Catzc.Base.QualityGates.LinkRelation]::Convention)
        @($edges.Line | Select-Object -Unique) | Should -Be @(0)
    }

    It 'returns no edge for no paths' {
        @(& $derive @()) | Should -HaveCount 0
    }
}
