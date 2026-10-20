<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Tooling.Core/tests/Test-Tool.Tests.ps1
    folder: tests
    name: test-tool-tests
    filetype: ps1
    role: test
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Tooling.Core
    moduletype: pwsh-folder
    catzc_bundle: azure
  edges:
    docs: "[Test-Tool.Tests.ps1.md](docs/references/pwsh/catzc-tooling-core/tests/Test-Tool.Tests.ps1.md)"
---
#>

Describe 'Test-Tool' -Tag 'L0', 'logic' {
    BeforeAll {
        function New-TestToolConfig {
            param([string] $Command, [string] $Version, [string] $DevboxVersion)
            $entry = @{ version = $Version; command = $Command; version_command = "$Command --version"; version_pattern = '(?<ver>.+)' }
            if ($DevboxVersion) {
                $entry.devbox_version = $DevboxVersion
            }
            [Catzc.Base.Execution.ToolConfig]::new($entry)
        }
    }
    BeforeEach {
        # The fixture az_cli carries a devbox_version lever on its ToolConfig; python has none.
        Mock Test-Command { $true } -ModuleName Catzc.Tooling.Core
    }

    It 'returns false when the command is not on PATH' {
        Mock Test-Command { $false } -ModuleName Catzc.Tooling.Core
        Mock Get-ToolConfig { New-TestToolConfig -Command 'az' -Version '2.87' -DevboxVersion '2.84' } -ModuleName Catzc.Tooling.Core
        Test-Tool 'az_cli' | Should -BeFalse
    }

    It 'returns true when the installed version matches the locked pin' {
        Mock Get-ToolConfig { New-TestToolConfig -Command 'az' -Version '2.87' -DevboxVersion '2.84' } -ModuleName Catzc.Tooling.Core
        Mock Get-ToolVersion { '2.87.1' } -ModuleName Catzc.Tooling.Core
        Mock Test-IsRunningInPipeline { $false } -ModuleName Catzc.Tooling.Core
        Test-Tool 'az_cli' | Should -BeTrue
    }

    Context 'devbox session (not a pipeline)' {
        BeforeEach { Mock Test-IsRunningInPipeline { $false } -ModuleName Catzc.Tooling.Core }

        It 'accepts an off-pin version matching devbox_version' {
            Mock Get-ToolConfig { New-TestToolConfig -Command 'az' -Version '2.87' -DevboxVersion '2.84' } -ModuleName Catzc.Tooling.Core
            Mock Get-ToolVersion { '2.84.0' } -ModuleName Catzc.Tooling.Core
            Test-Tool 'az_cli' | Should -BeTrue
        }

        It 'rejects an off-pin version for a tool with no devbox_version lever' {
            Mock Get-ToolConfig { New-TestToolConfig -Command 'python' -Version '3.14' } -ModuleName Catzc.Tooling.Core
            Mock Get-ToolVersion { '3.11.9' } -ModuleName Catzc.Tooling.Core
            Test-Tool 'python' | Should -BeFalse
        }
    }

    Context 'pipeline session (deterministically locked)' {
        BeforeEach { Mock Test-IsRunningInPipeline { $true } -ModuleName Catzc.Tooling.Core }

        It 'ignores devbox_version and rejects an off-pin version' {
            Mock Get-ToolConfig { New-TestToolConfig -Command 'az' -Version '2.87' -DevboxVersion '2.84' } -ModuleName Catzc.Tooling.Core
            Mock Get-ToolVersion { '2.84.0' } -ModuleName Catzc.Tooling.Core
            Test-Tool 'az_cli' | Should -BeFalse
        }
    }

    It 'with -SkipVersionCheck returns true for any present, functional tool' {
        Mock Get-ToolConfig { New-TestToolConfig -Command 'python' -Version '3.14' } -ModuleName Catzc.Tooling.Core
        Mock Get-ToolVersion { '3.11.9' } -ModuleName Catzc.Tooling.Core
        Test-Tool 'python' -SkipVersionCheck | Should -BeTrue
    }

    Context 'the probe (Resolve-ToolExecutable)' {
        BeforeEach {
            $script:probe = [Catzc.Base.Execution.ExecutableProbe]::new('widget', '/opt/widget', 'probe', '3.0.1', '3.0', $true, 1, 0, 'Person')
            Mock Resolve-ToolExecutable { $script:probe } -ModuleName Catzc.Tooling.Core
            Mock Get-ToolVersion { '3.0.1' } -ModuleName Catzc.Tooling.Core
        }

        It 'returns the probe record with -PassThru, for a tool without candidate paths too' {
            Mock Get-ToolConfig { New-TestToolConfig -Command 'widget' -Version '3.0' } -ModuleName Catzc.Tooling.Core
            Test-Tool 'widget' -PassThru | Should -Be $script:probe
        }

        It 'checks a tool without candidate paths by its command name' {
            Mock Get-ToolConfig { New-TestToolConfig -Command 'widget' -Version '3.0' } -ModuleName Catzc.Tooling.Core
            Test-Tool 'widget' | Should -BeTrue
            Should -Invoke Resolve-ToolExecutable -ModuleName Catzc.Tooling.Core -Times 0 -Exactly
        }

        It 'checks a tool with candidate paths through the probe' {
            Mock Get-ToolConfig {
                [Catzc.Base.Execution.ToolConfig]::new(@{ version = '3.0'; command = 'widget'; version_command = 'widget --version'; version_pattern = '(?<ver>.+)'; unix_probes = @('/opt/widget') })
            } -ModuleName Catzc.Tooling.Core
            Test-Tool 'widget' | Should -BeTrue
            Should -Invoke Resolve-ToolExecutable -ModuleName Catzc.Tooling.Core -Times 1 -Exactly -ParameterFilter { $Tool -eq 'widget' }
            Should -Invoke Test-Command -ModuleName Catzc.Tooling.Core -Times 0 -Exactly
        }

        It 'reads a probed tool as VersionOk, and as found with a version under -SkipVersionCheck' -ForEach @(
            @{ version = '2.9.0'; ok = $false; present = $true }
            @{ version = $null; ok = $false; present = $false }
        ) {
            Mock Get-ToolConfig {
                [Catzc.Base.Execution.ToolConfig]::new(@{ version = '3.0'; command = 'widget'; version_command = 'widget --version'; version_pattern = '(?<ver>.+)'; unix_probes = @('/opt/widget') })
            } -ModuleName Catzc.Tooling.Core
            Mock Resolve-ToolExecutable { [Catzc.Base.Execution.ExecutableProbe]::new('widget', '/opt/widget', 'probe', $version, '3.0', $false, 1, 0, 'Person') } -ModuleName Catzc.Tooling.Core
            Test-Tool 'widget' | Should -Be $ok
            Test-Tool 'widget' -SkipVersionCheck | Should -Be $present
        }
    }
}
