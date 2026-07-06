# cspell:ignore lockedtool
Describe 'Assert-ToolVersion' -Tag 'L0', 'logic' {
    # Hermetic: every collaborator is mocked in the module scope, so the assertion binds to the version-check
    # LOGIC (pipeline lock vs devbox lever), never to the shipped tools.yml values or the installed toolchain.
    # Fixture tools (ADR-TEST:3): faketool carries a devbox_version lever, lockedtool has none.
    BeforeEach {
        # The per-session pass cache would short-circuit repeated tool checks — clear it between cases.
        & (Get-Module Catzc.Tooling.Core) { $script:toolVersionCache = @{} }
        Mock Get-ToolCommandSuffix { 'Faketool' } -ModuleName Catzc.Tooling.Core
        Mock Get-Command { [pscustomobject]@{ Source = 'C:\faketool' } } -ModuleName Catzc.Tooling.Core
        Mock Get-Config -ModuleName Catzc.Tooling.Core -ParameterFilter { $Config -eq 'tools' } -MockWith {
            @{ faketool = @{ devbox_version = '2.84' }; lockedtool = @{} }
        }
    }

    Context 'devbox session (not a pipeline)' {
        BeforeEach { Mock Test-IsRunningInPipeline { $false } -ModuleName Catzc.Tooling.Core }

        It 'accepts an installed version matching devbox_version even when off the locked pin' {
            Mock Get-ToolConfig { [pscustomobject]@{ version = '2.87'; command = 'faketool' } } -ModuleName Catzc.Tooling.Core
            Mock Get-ToolVersion { '2.84.0' } -ModuleName Catzc.Tooling.Core
            { & (Get-Module Catzc.Tooling.Core) { Assert-ToolVersion -Tool 'faketool' } } | Should -Not -Throw
        }

        It 'still enforces the locked version for a tool with no devbox_version lever' {
            Mock Get-ToolConfig { [pscustomobject]@{ version = '3.14'; command = 'lockedtool' } } -ModuleName Catzc.Tooling.Core
            Mock Get-ToolVersion { '3.11.0' } -ModuleName Catzc.Tooling.Core
            { & (Get-Module Catzc.Tooling.Core) { Assert-ToolVersion -Tool 'lockedtool' } } | Should -Throw '*version mismatch*'
        }
    }

    Context 'pipeline session (deterministically locked)' {
        BeforeEach { Mock Test-IsRunningInPipeline { $true } -ModuleName Catzc.Tooling.Core }

        It 'ignores devbox_version and rejects an off-pin version' {
            Mock Get-ToolConfig { [pscustomobject]@{ version = '2.87'; command = 'faketool' } } -ModuleName Catzc.Tooling.Core
            Mock Get-ToolVersion { '2.84.0' } -ModuleName Catzc.Tooling.Core
            { & (Get-Module Catzc.Tooling.Core) { Assert-ToolVersion -Tool 'faketool' } } | Should -Throw '*version mismatch*'
        }

        It 'accepts an installed version matching the locked pin' {
            Mock Get-ToolConfig { [pscustomobject]@{ version = '2.87'; command = 'faketool' } } -ModuleName Catzc.Tooling.Core
            Mock Get-ToolVersion { '2.87.1' } -ModuleName Catzc.Tooling.Core
            { & (Get-Module Catzc.Tooling.Core) { Assert-ToolVersion -Tool 'faketool' } } | Should -Not -Throw
        }
    }
}
