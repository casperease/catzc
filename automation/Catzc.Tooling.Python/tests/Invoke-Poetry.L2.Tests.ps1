<#
---
catzc:
  derived:
    path: automation/Catzc.Tooling.Python/tests/Invoke-Poetry.L2.Tests.ps1
    kind: test
    language: powershell
    filetype: ps1
    track: automation
    module: Catzc.Tooling.Python
    moduletype: pwsh-folder-module
    bundle: azure
---
#>

Describe 'Invoke-Poetry' -Tag 'L2', 'logic' {
    BeforeAll {
        $script:available = Test-Tool 'poetry'
    }

    It 'lists poetry configuration' {
        if (-not $script:available) {
            Set-ItResult -Skipped -Because 'tool_poetry_missing'; return
        }
        $result = Invoke-Poetry 'config --list' -PassThru -Silent
        $result.ExitCode | Should -Be 0
        $result.Output | Should -Match 'virtualenvs'
    }
}
