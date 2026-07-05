Describe 'Test-Tool' -Tag 'L0', 'logic' {
    # Hermetic: every collaborator mocked in module scope, so the assertion binds to the version-gate LOGIC
    # (pin vs devbox lever vs pipeline), never to the shipped tools.yml or the installed toolchain.
    BeforeEach {
        Mock Test-Command { $true } -ModuleName Catzc.Tooling.Core
        Mock Get-Config -ModuleName Catzc.Tooling.Core -ParameterFilter { $Config -eq 'tools' } -MockWith {
            @{ az_cli = @{ devbox_version = '2.84' }; python = @{} }
        }
    }

    It 'returns false when the command is not on PATH' {
        Mock Test-Command { $false } -ModuleName Catzc.Tooling.Core
        Mock Get-ToolConfig { [pscustomobject]@{ command = 'az'; version = '2.87' } } -ModuleName Catzc.Tooling.Core
        Test-Tool 'az_cli' | Should -BeFalse
    }

    It 'returns true when the installed version matches the locked pin' {
        Mock Get-ToolConfig { [pscustomobject]@{ command = 'az'; version = '2.87' } } -ModuleName Catzc.Tooling.Core
        Mock Get-ToolVersion { '2.87.1' } -ModuleName Catzc.Tooling.Core
        Mock Test-IsRunningInPipeline { $false } -ModuleName Catzc.Tooling.Core
        Test-Tool 'az_cli' | Should -BeTrue
    }

    Context 'devbox session (not a pipeline)' {
        BeforeEach { Mock Test-IsRunningInPipeline { $false } -ModuleName Catzc.Tooling.Core }

        It 'accepts an off-pin version matching devbox_version' {
            Mock Get-ToolConfig { [pscustomobject]@{ command = 'az'; version = '2.87' } } -ModuleName Catzc.Tooling.Core
            Mock Get-ToolVersion { '2.84.0' } -ModuleName Catzc.Tooling.Core
            Test-Tool 'az_cli' | Should -BeTrue
        }

        It 'rejects an off-pin version for a tool with no devbox_version lever' {
            Mock Get-ToolConfig { [pscustomobject]@{ command = 'python'; version = '3.14' } } -ModuleName Catzc.Tooling.Core
            Mock Get-ToolVersion { '3.11.9' } -ModuleName Catzc.Tooling.Core
            Test-Tool 'python' | Should -BeFalse
        }
    }

    Context 'pipeline session (deterministically locked)' {
        BeforeEach { Mock Test-IsRunningInPipeline { $true } -ModuleName Catzc.Tooling.Core }

        It 'ignores devbox_version and rejects an off-pin version' {
            Mock Get-ToolConfig { [pscustomobject]@{ command = 'az'; version = '2.87' } } -ModuleName Catzc.Tooling.Core
            Mock Get-ToolVersion { '2.84.0' } -ModuleName Catzc.Tooling.Core
            Test-Tool 'az_cli' | Should -BeFalse
        }
    }

    It 'with -SkipVersionCheck returns true for any present, functional tool' {
        Mock Get-ToolConfig { [pscustomobject]@{ command = 'python'; version = '3.14' } } -ModuleName Catzc.Tooling.Core
        Mock Get-ToolVersion { '3.11.9' } -ModuleName Catzc.Tooling.Core
        Test-Tool 'python' -SkipVersionCheck | Should -BeTrue
    }
}
