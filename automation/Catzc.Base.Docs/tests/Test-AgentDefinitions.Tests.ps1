<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Docs/tests/Test-AgentDefinitions.Tests.ps1
    kind: pester-test
    adrs:
      - ADR-AUTO-TEST#3
      - ADR-AUTO-TEST#35
      - ADR-REPO-AGENTS#1
      - ADR-REPO-AGENTS#2
      - ADR-REPO-AGENTS#3
      - ADR-REPO-AGENTS#4
      - ADR-REPO-AGENTS#5
---
#>

# Test-AgentDefinitions over a fixture.claude/ tree in $TestDrive and a fixture AgentsConfig (Get-Config,...
# [comment:1](/docs/references/automation/catzc-base-docs/tests/Test-AgentDefinitions.Tests.ps1.md#comment1)
Describe 'Test-AgentDefinitions' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:out = Join-Path $TestDrive 'out'

        function Write-AgentFixture {
            param([string] $Relative, [string[]] $Text)
            $path = Join-Path $TestDrive "claude/$Relative"
            [void][System.IO.Directory]::CreateDirectory((Split-Path $path -Parent))
            [System.IO.File]::WriteAllText($path, ($Text -join "`n") + "`n")
        }

        function New-AgentsFixture {
            param([object[]] $Agents)
            [Catzc.Base.Docs.AgentsConfig]::new([ordered]@{ standard = 'widget'; agents = $Agents })
        }

        $script:widgetEntry = [ordered]@{ name = 'widget'; supported_by = @('ADR-WI-ONE#1'); checks = @('Get-Glossary') }
        $script:gadgetEntry = [ordered]@{ name = 'gadget'; supported_by = @('ADR-WI-ONE#2'); checks = @() }
        $script:widgetFile = @('---', 'name: widget', 'description: >', '  The standard agent. Do NOT use it for gadget work.', 'tools: Read, Edit', '---', '', '# Widget')
        $script:gadgetFile = @('---', 'name: gadget', 'description: The gadget agent. Do NOT use it for widget work.', 'tools: Read', '---', '', '# Gadget')
        $script:claudeMd = "# Claude`n`n## Sub-agents`n`n- **``widget``** — the standard agent.`n- **``gadget``** — the gadget agent.`n`n## Rules`n`n- **``gizmo``** — not an agent bullet.`n"
    }

    BeforeEach {
        $root = Join-Path $TestDrive 'claude'
        if (Test-Path -LiteralPath $root) {
            Remove-Item -LiteralPath $root -Recurse -Force
        }
        Write-AgentFixture 'agents/widget.md' $script:widgetFile
        Write-AgentFixture 'agents/gadget.md' $script:gadgetFile
        Write-AgentFixture 'CLAUDE.md' $script:claudeMd
        $script:fixture = New-AgentsFixture @($script:widgetEntry, $script:gadgetEntry)

        Mock Get-Config -ModuleName Catzc.Base.Docs -ParameterFilter { $Config -eq 'agents' } { $script:fixture }
        Mock Resolve-RepoPath -ModuleName Catzc.Base.Docs -ParameterFilter { $Path -eq '.claude/agents' } { Join-Path $TestDrive 'claude/agents' }
        Mock Resolve-RepoPath -ModuleName Catzc.Base.Docs -ParameterFilter { $Path -eq '.claude/CLAUDE.md' } { Join-Path $TestDrive 'claude/CLAUDE.md' }
        Mock Get-CatsAdrRuleIds -ModuleName Catzc.Base.Docs { , @('ADR-WI-ONE:1', 'ADR-WI-ONE:2') }
        Mock Write-Message -ModuleName Catzc.Base.Reports { }
    }

    It 'passes when the files, the registry, and the CLAUDE.md list agree' -Tag 'ADR-AUTO-TEST#35' {
        $result = Test-AgentDefinitions -OutputFolder $out -PassThru
        $result.Issues | Should -BeNullOrEmpty
        $result.IssueCount | Should -Be 0
        $result.Agents | Should -Be 2
        $result.Files | Should -Be 2
    }

    It 'reports an agent file with no entry and an entry with no file' -Tag 'ADR-REPO-AGENTS#2' {
        Remove-Item -LiteralPath (Join-Path $TestDrive 'claude/agents/gadget.md')
        Write-AgentFixture 'agents/gizmo.md' @('---', 'name: gizmo', 'description: Gizmo. Do NOT use it.', 'tools: Read', '---')
        $issues = (Test-AgentDefinitions -OutputFolder $out -PassThru).Issues
        $issues | Should -Contain '.claude/agents/gizmo.md: has no entry in agents.yml'
        $issues | Should -Contain "agents.yml: agent 'gadget' has no file .claude/agents/gadget.md"
    }

    It 'reports front matter that is missing or does not parse' -Tag 'ADR-REPO-AGENTS#1' {
        Write-AgentFixture 'agents/gadget.md' "# Gadget`n"
        Write-AgentFixture 'agents/widget.md' @('---', 'name: [widget', '---')
        $issues = (Test-AgentDefinitions -OutputFolder $out -PassThru).Issues
        $issues | Should -Contain '.claude/agents/gadget.md: has no front matter: the first line must be ---'
        @($issues | Where-Object { $_ -like '.claude/agents/widget.md: has front matter that is not valid YAML*' }) | Should -HaveCount 1
    }

    It 'reports a name that differs from the file name, and a missing description, Do NOT clause, or tools' -Tag 'ADR-REPO-AGENTS#1' {
        Write-AgentFixture 'agents/gadget.md' @('---', 'name: gizmo', 'description: The gadget agent.', '---')
        Write-AgentFixture 'agents/widget.md' @('---', 'name: widget', 'tools: Read', '---')
        $issues = (Test-AgentDefinitions -OutputFolder $out -PassThru).Issues
        $issues | Should -Contain ".claude/agents/gadget.md: front-matter name 'gizmo' must equal the file name 'gadget'"
        $issues | Should -Contain ".claude/agents/gadget.md: description has no 'Do NOT' clause saying when not to use the agent"
        $issues | Should -Contain '.claude/agents/gadget.md: front matter has no tools'
        $issues | Should -Contain '.claude/agents/widget.md: front matter has no description'
    }

    It 'reports a citation that names no rule and a check that names no command' -Tag 'ADR-REPO-AGENTS#2' {
        $script:fixture = New-AgentsFixture @(
            $script:widgetEntry,
            [ordered]@{ name = 'gadget'; supported_by = @('ADR-WI-ONE#9'); checks = @('Test-GadgetWidgetGizmo') }
        )
        $issues = (Test-AgentDefinitions -OutputFolder $out -PassThru).Issues
        $issues | Should -Contain "agents.yml: agent 'gadget' supported_by 'ADR-WI-ONE#9' names no ADR rule"
        $issues | Should -Contain "agents.yml: agent 'gadget' checks 'Test-GadgetWidgetGizmo' names no command"
        $issues | Should -HaveCount 2
    }

    It 'reports a registered agent CLAUDE.md does not list and a listed agent the registry lacks' -Tag 'ADR-REPO-AGENTS#3' {
        Write-AgentFixture 'CLAUDE.md' "# Claude`n`n## Sub-agents`n`n- **``widget``** — the standard agent.`n- **``gizmo``** — gone.`n"
        $issues = (Test-AgentDefinitions -OutputFolder $out -PassThru).Issues
        $issues | Should -Contain ".claude/CLAUDE.md: the Sub-agents section does not list registered agent 'gadget'"
        $issues | Should -Contain ".claude/CLAUDE.md: the Sub-agents section lists 'gizmo', which agents.yml does not register"
        $issues | Should -HaveCount 2
    }

    It 'reports a specialised agent the standard agent does not name' -Tag 'ADR-REPO-AGENTS#4' {
        Write-AgentFixture 'agents/widget.md' @('---', 'name: widget', 'description: The standard agent. Do NOT use it for special work.', 'tools: Read', '---')
        $issues = (Test-AgentDefinitions -OutputFolder $out -PassThru).Issues
        $issues | Should -Be @(".claude/agents/widget.md: the standard agent's description does not name specialised agent 'gadget'")
    }

    It 'throws once listing every issue without -PassThru' -Tag 'ADR-AUTO-TEST#35' {
        Remove-Item -LiteralPath (Join-Path $TestDrive 'claude/agents/gadget.md')
        $thrown = { Test-AgentDefinitions -OutputFolder $out } | Should -Throw -PassThru
        $thrown.Exception.Message | Should -BeLike 'Test-AgentDefinitions failed: 1 issue(s)*'
        $thrown.Exception.Message | Should -Match "agent 'gadget' has no file"
    }
}

# The real tree: every agent file, the shipped agents.yml, the real rule ids and commands, and.claude/CLAUDE.md.
# [comment:2](/docs/references/automation/catzc-base-docs/tests/Test-AgentDefinitions.Tests.ps1.md#comment2)
Describe 'Test-AgentDefinitions — real agent definitions' -Tag 'L1', 'integrity', 'source-only' {
    It 'Test-AgentDefinitions passes over the real tree' -Tag 'ADR-AUTO-TEST#35', 'ADR-REPO-AGENTS#5' {
        $result = Test-AgentDefinitions -PassThru -OutputFolder (Join-Path $TestDrive 'agents')
        $result.Issues | Should -BeNullOrEmpty
        $result.IssueCount | Should -Be 0
    }
}
