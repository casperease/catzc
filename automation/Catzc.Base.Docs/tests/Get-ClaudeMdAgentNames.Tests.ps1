<#
---
catzc:
  immutable:
    path: automation/Catzc.Base.Docs/tests/Get-ClaudeMdAgentNames.Tests.ps1
    folder: tests
    name: get-claude-md-agent-names-tests
    filetype: ps1
    kind: test
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.Docs
    moduletype: pwsh-folder
    catzc_bundle: azure
  edges:
    page: docs/references/automation/catzc-base-docs/tests/Get-ClaudeMdAgentNames.Tests.ps1.md
    cites:
      - ADR-AUTO-TEST#3
      - ADR-REPO-AGENTS#3
---
#>

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
