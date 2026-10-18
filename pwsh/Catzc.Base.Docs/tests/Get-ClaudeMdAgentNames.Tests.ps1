Describe 'Get-ClaudeMdAgentNames' -Tag 'L0', 'logic', 'ADR-REPO-AGENTS#3' {
    BeforeAll {
        function Write-ClaudeMdFixture {
            param([string] $Text)
            $path = Join-Path $TestDrive 'CLAUDE.md'
            [System.IO.File]::WriteAllText($path, $Text)
            $path
        }
    }

    It 'returns the bold-code bullets of the Sub-agents section only, in file order' {
        $path = Write-ClaudeMdFixture (@(
                '# Claude', '', '- **`gizmo`** — before the section.', '', '## Sub-agents', '', 'Prose naming **`gizmo`**.', '',
                '- **`widget`** — the standard agent,', '  continued **`gizmo`**.', '- **`gadget`** — the gadget agent.', '',
                '### Detail', '', '- **`sprocket`** — under a subheading.', '', '## Rules', '', '- **`gizmo`** — after the section.'
            ) -join "`n")
        $names = InModuleScope Catzc.Base.Docs -Parameters @{ Path = $path } { Get-ClaudeMdAgentNames -Path $Path }
        $names | Should -Be @('widget', 'gadget', 'sprocket')
    }

    It 'returns nothing when there is no Sub-agents section' {
        $path = Write-ClaudeMdFixture "# Claude`n`n## Rules`n`n- **``widget``** — not an agent.`n"
        $names = InModuleScope Catzc.Base.Docs -Parameters @{ Path = $path } { Get-ClaudeMdAgentNames -Path $Path }
        $names | Should -BeNullOrEmpty
    }
}
