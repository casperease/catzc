<#
---
catzc:
  docs: "../../../../docs/references/pwsh/catzc-base-execution/tests/types/CliRunner.Tests.ps1.md"
  header: "generated"
---
#>

Describe 'CliRunner.ExecutableName' -Tag 'L0', 'logic' {

    # The name a time limit is looked up by: a wrong parse gives the command another executable's limit.
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

Describe 'CliRunner.RunMany' -Tag 'L0', 'logic' {
    It 'refuses <case> before starting anything' -ForEach @(
        @{ case = 'a null command list'; Commands = $null; Limits = [int[]] @(); Throttle = 1; Message = '*commandLines*' }
        @{ case = 'a time limit per command missing'; Commands = [string[]] @('widget'); Limits = [int[]] @(); Throttle = 1
            Message = '*own time limit*'
        }
        @{ case = 'a throttle below one'; Commands = [string[]] @('widget'); Limits = [int[]] @(5); Throttle = 0
            Message = '*at least one process*'
        }
    ) {
        { [Catzc.Base.Execution.CliRunner]::RunMany($Commands, $TestDrive, $Limits, 5, $Throttle) } | Should -Throw $Message
    }

    It 'returns an empty result for an empty command list, starting nothing' {
        @([Catzc.Base.Execution.CliRunner]::RunMany([string[]] @(), $TestDrive, [int[]] @(), 5, 4)) | Should -HaveCount 0
    }
}
