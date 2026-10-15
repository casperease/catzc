<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Timeouts/tests/types/BoundedCommand.Tests.ps1
    kind: pester-test
---
#>

Describe 'BoundedCommand' -Tag 'L0', 'logic' {
    BeforeDiscovery {
        # Every case, every engine, from the per-engine fixture table: a case that does not apply to an engine says why
        # there ("n/a: <reason>"), so pwsh/bash/zsh parity reads side by side in one file.
        $script:cases = @(Get-EngineCaseTable (Join-Path $PSScriptRoot '../assets/engine-cases/bounded-command.yml') -Applicable)
    }

    It '<Engine>: <Case> is <Fields.expect>' -ForEach $cases {
        $requested = $null
        [Catzc.Base.Timeouts.BoundedCommand]::Check($Fields.command, $Engine, 70, [ref] $requested) | Should -Be $Fields.expect
        $requested | Should -Not -BeNullOrEmpty
    }

    It 'parses the bash prefix into its duration and the one command' {
        $seconds = $null
        $body = $null
        [Catzc.Base.Timeouts.BoundedCommand]::TryParseBound('timeout -k 5 2m get-widget --all', 'bash', [ref] $seconds, [ref] $body) | Should -BeTrue
        $seconds | Should -Be 120
        $body | Should -Be 'get-widget --all'
    }

    It 'parses the pwsh call into its -Seconds and the block content, or no seconds for the configured default' {
        $seconds = $null
        $body = $null
        [Catzc.Base.Timeouts.BoundedCommand]::TryParseBound('Invoke-WithTimeout { Get-Widget } -Seconds 45', 'pwsh', [ref] $seconds, [ref] $body) | Should -BeTrue
        $seconds | Should -Be 45
        $body | Should -Be 'Get-Widget'
        [Catzc.Base.Timeouts.BoundedCommand]::TryParseBound('Test-CompletesWithin { Get-Gadget }', 'pwsh', [ref] $seconds, [ref] $body) | Should -BeTrue
        $seconds | Should -BeNullOrEmpty
    }

    It 'parses the zsh prefix as the bash one: the same GNU timeout' {
        $seconds = $null
        $body = $null
        [Catzc.Base.Timeouts.BoundedCommand]::TryParseBound('timeout -k 5 2m get-widget --all', 'zsh', [ref] $seconds, [ref] $body) | Should -BeTrue
        $seconds | Should -Be 120
        $body | Should -Be 'get-widget --all'
    }

    It 'throws on a name that is not an execution engine' {
        $requested = $null
        { [Catzc.Base.Timeouts.BoundedCommand]::Check('get-widget', 'widget', 70, [ref] $requested) } | Should -Throw "*'widget' is not an execution engine (one of: pwsh, bash, zsh)*"
    }
}
