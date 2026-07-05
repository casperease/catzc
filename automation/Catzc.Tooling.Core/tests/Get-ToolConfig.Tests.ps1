Describe 'Get-ToolConfig' -Tag 'L0' {
    # Discovery-time: populates -ForEach data before tests run
    $script:configPath = Join-Path $PSScriptRoot '../configs/tools.yml'
    $script:allTools = Get-Content $configPath -Raw | ConvertFrom-Yaml
    $script:toolEntries = foreach ($key in $script:allTools.Keys) {
        @{ Tool = $key; Config = $script:allTools[$key] }
    }
    $script:depEntries = foreach ($entry in $script:toolEntries) {
        if ($entry.Config['depends_on']) {
            @{ Tool = $entry.Tool; DependsOn = $entry.Config['depends_on'] }
        }
    }

    # Run-time: makes data available inside It blocks
    BeforeAll {
        $script:configPath = Join-Path $PSScriptRoot '../configs/tools.yml'
        $script:allTools = Get-Content $configPath -Raw | ConvertFrom-Yaml
    }

    Context 'asset dependencies' -Tag 'integrity' {
        It 'tools.yml exists' {
            Join-Path $PSScriptRoot '../configs/tools.yml' | Should -Exist
        }
    }

    Context 'structural validation' -Tag 'integrity' {
        It 'tools.yml has at least one tool defined' {
            $script:allTools.Keys.Count | Should -BeGreaterThan 0
        }

        It '<Tool> has required fields' -ForEach $script:toolEntries {
            $Config.version | Should -Not -BeNullOrEmpty -Because "$Tool needs a locked version"
            $Config.command | Should -Not -BeNullOrEmpty -Because "$Tool needs a command name"
            $Config.version_command | Should -Not -BeNullOrEmpty -Because "$Tool needs a version probe command"
            $Config.version_pattern | Should -Not -BeNullOrEmpty -Because "$Tool needs a version regex"
        }

        It '<Tool> VersionPattern has a named capture group "ver"' -ForEach $script:toolEntries {
            $Config.version_pattern | Should -Match '\(\?<ver>' -Because 'version_pattern must capture as (?<ver>...)'
        }

        It '<Tool> has at least one install mechanism' -ForEach $script:toolEntries {
            $hasMechanism = $Config['winget_id'] -or $Config['brew_formula'] -or $Config['apt_package'] -or $Config['pip_package'] -or $Config['script_install'] -or $Config['npm_package'] -or $Config['uv_tool'] -or $Config['uv_python']
            $hasMechanism | Should -BeTrue -Because "$Tool needs WingetId, BrewFormula, AptPackage, PipPackage, ScriptInstall, NpmPackage, UvTool, or UvPython"
        }

        It '<Tool> DependsOn references an existing tool' -ForEach $script:depEntries {
            $script:allTools.Keys | Should -Contain $DependsOn -Because "$Tool depends on $DependsOn which must exist in tools.yml"
        }
    }

    Context 'Install/Uninstall function coverage' -Tag 'integrity' {
        It '<Tool> has an Install-<Tool> function' -ForEach $script:toolEntries {
            $suffix = & (Get-Module Catzc.Tooling.Core) { Get-ToolCommandSuffix -Tool $args[0] } $Tool
            Get-Command "Install-$suffix" -ErrorAction SilentlyContinue | Should -Not -BeNullOrEmpty -Because "every tool needs an Install-$suffix function"
        }

        It '<Tool> has an Uninstall-<Tool> function' -ForEach $script:toolEntries {
            $suffix = & (Get-Module Catzc.Tooling.Core) { Get-ToolCommandSuffix -Tool $args[0] } $Tool
            Get-Command "Uninstall-$suffix" -ErrorAction SilentlyContinue | Should -Not -BeNullOrEmpty -Because "every tool needs an Uninstall-$suffix function"
        }
    }

    Context 'Get-ToolConfig behavior' -Tag 'logic' {
        It 'returns config for <Tool>' -ForEach $script:toolEntries {
            $script:result = & (Get-Module Catzc.Tooling.Core) { Get-ToolConfig -Tool $args[0] } $Tool
            $result | Should -Not -BeNullOrEmpty
            $result.version | Should -Be $Config.version
            $result.command | Should -Be $Config.command
        }

        It 'throws for unknown tool' {
            { & (Get-Module Catzc.Tooling.Core) { Get-ToolConfig -Tool 'FakeTool' } } | Should -Throw '*Unknown tool*'
        }

        It 'caches across calls' {
            $script:first = & (Get-Module Catzc.Tooling.Core) { Get-ToolConfig -Tool 'python' }
            $script:second = & (Get-Module Catzc.Tooling.Core) { Get-ToolConfig -Tool 'python' }
            [object]::ReferenceEquals($first, $second) | Should -BeTrue -Because 'repeated calls should return the same cached object'
        }
    }
}
