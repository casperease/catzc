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
            [Catzc.Base.Docs.AgentsConfig]::new([ordered]@{ standard = 'widget'; agents = $Agents; contracts = @('ADR-WI') })
        }

        function New-CapabilitiesFixture {
            param([object[]] $Capabilities)
            [Catzc.Base.Docs.CapabilitiesConfig]::new([ordered]@{ capabilities = $Capabilities })
        }

        $script:widgetEntry = [ordered]@{ name = 'widget'; supported_by = @('ADR-WI-ONE#1'); checks = @('Get-Glossary') }
        $script:gadgetEntry = [ordered]@{ name = 'gadget'; supported_by = @('ADR-WI-ONE#2'); checks = @() }
        $script:spinEntry = [ordered]@{ name = 'widget-spin'; supported_by = @('ADR-WI-ONE#1'); checks = @() }
        $script:widgetFile = @('---', 'name: widget', 'description: >', '  The standard agent. Do NOT use it for gadget work.', 'tools: Read, Edit', 'model: haiku', 'skills: [widget-spin]', '---', '', '# Widget')
        $script:gadgetFile = @('---', 'name: gadget', 'description: The gadget agent. Do NOT use it for widget work.', 'tools: Read', 'model: haiku', '---', '', '# Gadget')
        $script:spinFile = @('---', 'name: widget-spin', 'description: Spin a widget; for widget; input is the widget.', 'user-invocable: false', 'allowed-tools: Read',
            'metadata:', '  catzc:', '    immutable:', '      kind: capability', '    config:', '      model_floor: haiku', '      needs: []', '---', '1. Spin it.', '2. Report.')
        $script:claudeMd = "# Claude`n`n## Sub-agents`n`nEvery robot reads ADR-WI first.`n`n- **``widget``** — the standard agent.`n- **``gadget``** — the gadget agent.`n`n## Rules`n`n- **``gizmo``** — not an agent bullet.`n"
    }

    BeforeEach {
        $root = Join-Path $TestDrive 'claude'
        if (Test-Path -LiteralPath $root) {
            Remove-Item -LiteralPath $root -Recurse -Force
        }
        Write-AgentFixture 'agents/widget.md' $script:widgetFile
        Write-AgentFixture 'agents/gadget.md' $script:gadgetFile
        Write-AgentFixture 'skills/widget-spin/SKILL.md' $script:spinFile
        Write-AgentFixture 'CLAUDE.md' $script:claudeMd
        $script:fixture = New-AgentsFixture @($script:widgetEntry, $script:gadgetEntry)
        $script:capabilities = New-CapabilitiesFixture @($script:spinEntry)

        Mock Get-Config -ModuleName Catzc.Base.Docs -ParameterFilter { $Config -eq 'agents' } { $script:fixture }
        Mock Get-Config -ModuleName Catzc.Base.Docs -ParameterFilter { $Config -eq 'capabilities' } { $script:capabilities }
        Mock Resolve-RepoPath -ModuleName Catzc.Base.Docs -ParameterFilter { $Path -eq '.claude/agents' } { Join-Path $TestDrive 'claude/agents' }
        Mock Resolve-RepoPath -ModuleName Catzc.Base.Docs -ParameterFilter { $Path -eq '.claude/skills' } { Join-Path $TestDrive 'claude/skills' }
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
        $result.Capabilities | Should -Be 1
    }

    It 'reports a body over the roof, a key outside the robot set, and a key out of the fixed order' -Tag 'ADR-REPO-AGENTS#6' {
        $long = @('---', 'name: gadget', 'description: The gadget agent. Do NOT use it for widget work.', 'tools: Read', 'model: haiku', '---') + @(1..21 | ForEach-Object { "$_. step" })
        Write-AgentFixture 'agents/gadget.md' $long
        Write-AgentFixture 'agents/widget.md' @('---', 'name: widget', 'model: haiku', 'description: >', '  The standard agent. Do NOT use it for gadget work.', 'tools: Read', 'color: red', 'skills: [widget-spin]', '---', '# Widget')
        $issues = (Test-AgentDefinitions -OutputFolder $out -PassThru).Issues
        $issues | Should -Contain '.claude/agents/gadget.md: body has 21 lines, the roof is 20 (roofs.agent_body_lines)'
        @($issues | Where-Object { $_ -like ".claude/agents/widget.md: front-matter key 'description' is out of the fixed order*" }) | Should -HaveCount 1
        @($issues | Where-Object { $_ -like ".claude/agents/widget.md: front-matter key 'color' is outside the robot set*" }) | Should -HaveCount 1
    }

    It 'reports a missing or inherited model and a model below a preloaded floor' -Tag 'ADR-REPO-AGENTS#7' {
        Write-AgentFixture 'agents/gadget.md' @('---', 'name: gadget', 'description: The gadget agent. Do NOT use it for widget work.', 'tools: Read', 'model: inherit', '---', '# Gadget')
        Write-AgentFixture 'skills/widget-spin/SKILL.md' ($script:spinFile -replace 'model_floor: haiku', 'model_floor: sonnet')
        $issues = (Test-AgentDefinitions -OutputFolder $out -PassThru).Issues
        $issues | Should -Contain '.claude/agents/gadget.md: front matter must name a model (haiku, sonnet or opus), never inherit'
        $issues | Should -Contain ".claude/agents/widget.md: model 'haiku' is below the model_floor 'sonnet' of capability 'widget-spin'"
        $issues | Should -HaveCount 2
    }

    It 'reports a capability over its roof, with a wrong name, user-invocable, without allowed-tools or a floor' -Tag 'ADR-REPO-AGENTS#8' {
        $over = @('---', 'name: widget-spun', 'description: Spin.', 'user-invocable: true', 'metadata:', '  catzc:', '    config:', '      needs: []', '---') + @(1..7 | ForEach-Object { "$_. step" })
        Write-AgentFixture 'skills/widget-spin/SKILL.md' $over
        $issues = (Test-AgentDefinitions -OutputFolder $out -PassThru).Issues
        $issues | Should -Contain ".claude/skills/widget-spin/SKILL.md: front-matter name 'widget-spun' must equal the folder name 'widget-spin'"
        $issues | Should -Contain '.claude/skills/widget-spin/SKILL.md: front matter must set user-invocable: false'
        $issues | Should -Contain '.claude/skills/widget-spin/SKILL.md: front matter has no allowed-tools'
        $issues | Should -Contain '.claude/skills/widget-spin/SKILL.md: metadata.catzc.config.model_floor must be haiku, sonnet or opus'
        $issues | Should -Contain '.claude/skills/widget-spin/SKILL.md: has 11 lines outside its catzc head, the roof is 10 (roofs.capability_lines)'
    }

    It 'reports a skills name with no capability file and a capability no agent preloads' -Tag 'ADR-REPO-AGENTS#9' {
        Write-AgentFixture 'agents/widget.md' ($script:widgetFile -replace 'skills: \[widget-spin\]', 'skills: [widget-spun]')
        $issues = (Test-AgentDefinitions -OutputFolder $out -PassThru).Issues
        $issues | Should -Contain ".claude/agents/widget.md: skills names 'widget-spun', which has no file .claude/skills/widget-spun/SKILL.md"
        $issues | Should -Contain '.claude/skills/widget-spin/SKILL.md: no agent preloads it in its skills list'
        $issues | Should -HaveCount 2
    }

    It 'reports a capability file without an entry, an entry without a file, and an entry whose citation or check resolves to nothing' -Tag 'ADR-REPO-AGENTS#10' {
        $script:capabilities = New-CapabilitiesFixture @([ordered]@{ name = 'gadget-turn'; supported_by = @('ADR-WI-ONE#9'); checks = @('Test-GadgetWidgetGizmo') })
        $issues = (Test-AgentDefinitions -OutputFolder $out -PassThru).Issues
        $issues | Should -Contain '.claude/skills/widget-spin/SKILL.md: has no entry in capabilities.yml'
        $issues | Should -Contain "$(Get-CatzcModulesFolder)/Catzc.Base.Docs/configs/capabilities.yml: capability 'gadget-turn' has no file .claude/skills/gadget-turn/SKILL.md"
        $issues | Should -Contain "$(Get-CatzcModulesFolder)/Catzc.Base.Docs/configs/capabilities.yml: capability 'gadget-turn' supported_by 'ADR-WI-ONE#9' names no ADR rule"
        $issues | Should -Contain "$(Get-CatzcModulesFolder)/Catzc.Base.Docs/configs/capabilities.yml: capability 'gadget-turn' checks 'Test-GadgetWidgetGizmo' names no command"
        $issues | Should -HaveCount 4
    }

    It 'reports a CLAUDE.md that does not name a required contract, and a robot that carries a contracts key' -Tag 'ADR-REPO-AGENTS#6' {
        Write-AgentFixture 'CLAUDE.md' ($script:claudeMd -replace 'Every robot reads ADR-WI first\.', 'Every robot reads the contract first.')
        Write-AgentFixture 'agents/gadget.md' @('---', 'name: gadget', 'description: The gadget agent. Do NOT use it for widget work.', 'tools: Read', 'model: haiku', 'contracts: [ADR-WI]', '---', '# Gadget')
        $issues = (Test-AgentDefinitions -OutputFolder $out -PassThru).Issues
        $issues | Should -Contain ".claude/CLAUDE.md: does not name the contract 'ADR-WI' that agents.yml contracts requires every robot to read first"
        @($issues | Where-Object { $_ -like ".claude/agents/gadget.md: front-matter key 'contracts' is outside the robot set*" }) | Should -HaveCount 1
        $issues | Should -HaveCount 2
    }

    It 'counts a wrapped continuation with its line and a comment line as nothing' -Tag 'ADR-REPO-AGENTS#6', 'ADR-REPO-AGENTS#8' {
        $wrapped = @('---', 'name: gadget', 'description: >', '  The gadget agent.', '  Do NOT use it for widget work.', 'tools: Read', 'model: haiku', '---', '# gadget', '', '<!-- cspell:ignore gizmo -->') +
        @(1..19 | ForEach-Object { "$_. a step that the formatter"; '   wrapped onto a second line' })
        Write-AgentFixture 'agents/gadget.md' $wrapped
        $spin = @('---', 'name: widget-spin', 'description: Spin a widget; for widget; input is the widget.', 'user-invocable: false', 'allowed-tools: Read',
            'metadata:', '  catzc:', '    config:', '      model_floor: haiku', '      needs: []', '---', '# widget-spin', '', '1. Spin it', '   with care.', '2. Report', '   the spin.', '3. Stop.', '4. Rest.')
        Write-AgentFixture 'skills/widget-spin/SKILL.md' $spin
        $issues = (Test-AgentDefinitions -OutputFolder $out -PassThru).Issues
        $issues | Should -BeNullOrEmpty
    }

    It 'reports an agent file with no entry and an entry with no file' -Tag 'ADR-REPO-AGENTS#2' {
        Remove-Item -LiteralPath (Join-Path $TestDrive 'claude/agents/gadget.md')
        Write-AgentFixture 'agents/gizmo.md' @('---', 'name: gizmo', 'description: Gizmo. Do NOT use it.', 'tools: Read', '---')
        $issues = (Test-AgentDefinitions -OutputFolder $out -PassThru).Issues
        $issues | Should -Contain '.claude/agents/gizmo.md: has no entry in agents.yml'
        $issues | Should -Contain "$(Get-CatzcModulesFolder)/Catzc.Base.Docs/configs/agents.yml: agent 'gadget' has no file .claude/agents/gadget.md"
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
        $issues | Should -Contain "$(Get-CatzcModulesFolder)/Catzc.Base.Docs/configs/agents.yml: agent 'gadget' supported_by 'ADR-WI-ONE#9' names no ADR rule"
        $issues | Should -Contain "$(Get-CatzcModulesFolder)/Catzc.Base.Docs/configs/agents.yml: agent 'gadget' checks 'Test-GadgetWidgetGizmo' names no command"
        $issues | Should -HaveCount 2
    }

    It 'reports a registered agent CLAUDE.md does not list and a listed agent the registry lacks' -Tag 'ADR-REPO-AGENTS#3' {
        Write-AgentFixture 'CLAUDE.md' "# Claude`n`n## Sub-agents`n`nEvery robot reads ADR-WI first.`n`n- **``widget``** — the standard agent.`n- **``gizmo``** — gone.`n"
        $issues = (Test-AgentDefinitions -OutputFolder $out -PassThru).Issues
        $issues | Should -Contain ".claude/CLAUDE.md: the Sub-agents section does not list registered agent 'gadget'"
        $issues | Should -Contain ".claude/CLAUDE.md: the Sub-agents section lists 'gizmo', which agents.yml does not register"
        $issues | Should -HaveCount 2
    }

    It 'reports a specialised agent the standard agent does not name' -Tag 'ADR-REPO-AGENTS#4' {
        Write-AgentFixture 'agents/widget.md' @('---', 'name: widget', 'description: The standard agent. Do NOT use it for special work.', 'tools: Read', 'model: haiku', 'skills: [widget-spin]', '---')
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

Describe 'Test-AgentDefinitions — real agent definitions' -Tag 'L1', 'integrity', 'source-only' {
    It 'Test-AgentDefinitions passes over the real tree' -Tag 'ADR-AUTO-TEST#35', 'ADR-REPO-AGENTS#5' {
        $result = Test-AgentDefinitions -PassThru -OutputFolder (Join-Path $TestDrive 'agents')
        $result.Issues | Should -BeNullOrEmpty
        $result.IssueCount | Should -Be 0
    }
}

Describe 'Test-AgentDefinitions — shipped configs/agents.yml and configs/capabilities.yml' -Tag 'L1', 'integrity', 'ADR-AUTO-ASSETDEP#3' {
    It 'finds both registries it names in the loaded module' {
        $agents = [System.IO.File]::ReadAllText((Get-CatzcModuleRoot 'configs/agents.yml' -Module Catzc.Base.Docs)) | ConvertFrom-Yaml -Ordered
        $capabilities = [System.IO.File]::ReadAllText((Get-CatzcModuleRoot 'configs/capabilities.yml' -Module Catzc.Base.Docs)) | ConvertFrom-Yaml -Ordered
        @($agents['agents'] | ForEach-Object { $_['name'] }) | Should -Contain $agents['standard']
        @($capabilities['capabilities']).Count | Should -BeGreaterThan 0
    }
}
