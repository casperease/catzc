<#
---
catzc:
  derived:
    path: automation/Catzc.Tooling.Core/tests/Assert-Tool.Tests.ps1
    kind: test
    language: powershell
    filetype: ps1
    track: automation
    module: Catzc.Tooling.Core
    moduletype: pwsh-folder-module
    bundle: azure
    relatives:
      page: docs/references/automation/catzc-tooling-core/tests/Assert-Tool.Tests.ps1.md
    adrs:
      - ADR-AUTO-TEST#3
---
#>

Describe 'Assert-Tool' -Tag 'L0', 'logic' {
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
