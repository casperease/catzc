<#
---
catzc:
  derived:
    path: automation/Catzc.Tooling.Core/tests/Assert-Tool.Tests.ps1
    kind: pester-test
---
#>

Describe 'Assert-Tool' -Tag 'L0', 'logic' {
    # The probed branch: a tool with candidate paths is asserted from the probe record, never by its bare name on
    # PATH. The probe is mocked whole. Fixture tokens are neutral
    # ([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
    BeforeEach {
        Mock Get-ToolConfig {
            [Catzc.Base.Execution.ToolConfig]::new(@{ version = '5'; command = 'widget'; version_command = 'widget --version'; version_pattern = '(?<ver>.+)'; unix_probes = @('/opt/widget'); windows_probes = @('C:\widget.exe') })
        } -ModuleName Catzc.Tooling.Core
        Mock Assert-Command { throw 'Assert-Command must not run for a probed tool' } -ModuleName Catzc.Tooling.Core
    }

    It 'passes for a found tool at the locked version' {
        Mock Resolve-ToolExecutable { [Catzc.Base.Execution.ExecutableProbe]::new('widget', '/opt/widget', 'probe', '5.2', '5', $true, 1, 1, 'Person') } -ModuleName Catzc.Tooling.Core
        { Assert-Tool 'widget' } | Should -Not -Throw
    }

    It 'throws a self-contained message when the tool is not found' {
        Mock Resolve-ToolExecutable { [Catzc.Base.Execution.ExecutableProbe]::new('widget', $null, 'none', $null, '5', $false, 1, 0, 'Person') } -ModuleName Catzc.Tooling.Core
        { Assert-Tool 'widget' } | Should -Throw '*widget is not installed*candidate paths or on PATH*'
    }

    It 'throws on a version below the pin, naming the path, unless -SkipVersionCheck' {
        Mock Resolve-ToolExecutable { [Catzc.Base.Execution.ExecutableProbe]::new('widget', '/opt/widget', 'probe', '4.4', '5', $false, 1, 1, 'Person') } -ModuleName Catzc.Tooling.Core
        { Assert-Tool 'widget' } | Should -Throw "*expected 5.x, found 4.4 at '/opt/widget'*"
        { Assert-Tool 'widget' -SkipVersionCheck } | Should -Not -Throw
    }
}
