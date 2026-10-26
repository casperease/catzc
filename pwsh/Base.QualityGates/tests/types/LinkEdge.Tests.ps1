Describe 'LinkEdge' -Tag 'L0', 'logic', 'ADR-REPO-LINKS-EVERYLINKHASADIRECTION' {
    It 'keeps where it is written, its relation and its target, with no code for a plain link' {
        $edge = [Catzc.Base.QualityGates.LinkEdge]::new('docs/widget/part.md', 3, 7, 'MarkdownLink',
            'docs/gadget/spec.md', $null)
        $edge.File | Should -Be 'docs/widget/part.md'
        $edge.Line | Should -Be 3
        $edge.Column | Should -Be 7
        $edge.Relation | Should -Be ([Catzc.Base.QualityGates.LinkRelation]::MarkdownLink)
        $edge.Target | Should -Be 'docs/gadget/spec.md'
        $edge.Code | Should -BeExactly ''
    }

    It 'carries the rule code of a citation' {
        $edge = [Catzc.Base.QualityGates.LinkEdge]::new('mods/Widget/Get-Widget.ps1', 1, 1, 'CodeLink',
            'docs/drs/widget.md', 'ADR-WIDGET-ONE')
        $edge.Code | Should -Be 'ADR-WIDGET-ONE'
        "$edge" | Should -Be 'mods/Widget/Get-Widget.ps1:1:1 [CodeLink] docs/drs/widget.md'
    }

    It 'knows exactly the three written relations and the convention relation' {
        [enum]::GetNames([Catzc.Base.QualityGates.LinkRelation]) | Should -Be @('MarkdownLink', 'CodeLink', 'DocsEdge',
            'Convention')
    }

    It 'refuses an edge with no file or no target' {
        { [Catzc.Base.QualityGates.LinkEdge]::new('', 1, 1, 'DocsEdge', 'docs/gadget.md', '') } |
            Should -Throw '*written in a file*'
        { [Catzc.Base.QualityGates.LinkEdge]::new('mods/Widget/a.ps1', 1, 1, 'DocsEdge', '', '') } |
            Should -Throw '*names a target*'
    }
}
