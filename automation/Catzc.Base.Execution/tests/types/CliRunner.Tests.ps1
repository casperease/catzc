<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Execution/tests/types/CliRunner.Tests.ps1
    kind: pester-test
    adrs:
      - ADR-AUTO-TEST#3
---
#>

Describe 'CliRunner.ExecutableName' -Tag 'L0', 'logic' {
    # The name a command's time limit is looked up by (Get-TimeoutSeconds -Executable), so a wrong parse gives the...
    # [comment:1](/docs/references/automation/catzc-base-execution/tests/types/CliRunner.Tests.ps1.md#comment1)

    It 'reads the first token of <commandLine> as <expected>' -ForEach @(
        @{ commandLine = 'widget'; expected = 'widget' }
        @{ commandLine = 'widget build std'; expected = 'widget' }
        @{ commandLine = '  widget   --flag  '; expected = 'widget' }
        @{ commandLine = 'C:\tools\widget.exe --version'; expected = 'C:\tools\widget.exe' }
        @{ commandLine = '"C:\Program Files\Widget\widget.exe" build'; expected = 'C:\Program Files\Widget\widget.exe' }
        @{ commandLine = "'/opt/gadget tools/widget' run"; expected = '/opt/gadget tools/widget' }
    ) {
        [Catzc.Base.Execution.CliRunner]::ExecutableName($commandLine) | Should -BeExactly $expected
    }

    It 'reads a blank command (<case>) as an empty name' -ForEach @(
        @{ case = 'empty'; commandLine = '' }
        @{ case = 'whitespace'; commandLine = '   ' }
        @{ case = 'null'; commandLine = $null }
    ) {
        [Catzc.Base.Execution.CliRunner]::ExecutableName($commandLine) | Should -BeExactly ''
    }

    It 'reads no name from a command with a shell operator, which Invoke-Executable refuses to run' -ForEach @(
        'widget | gadget', 'widget && gadget', 'widget; gadget'
    ) {
        [Catzc.Base.Execution.CliRunner]::ExecutableName($_) | Should -BeExactly ''
    }
}
