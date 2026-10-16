<#
---
catzc:
  derived:
    path: automation/Catzc.Tooling.Node/tests/Invoke-Npm.L2.Tests.ps1
    folder: tests
    name: invoke-npm-l2-tests
    filetype: ps1
    kind: test
    language: powershell
    track: automation
    module: Catzc.Tooling.Node
    moduletype: pwsh-folder
    catzc_bundle: azure
---
#>

Describe 'Invoke-Npm' -Tag 'L2', 'logic' {
    BeforeAll {
        $script:available = Test-Tool 'node_js'
    }

    It 'prints npm root path' {
        if (-not $script:available) {
            Set-ItResult -Skipped -Because 'tool_node_missing'; return
        }
        $result = Invoke-Npm 'root' -PassThru -Silent
        $result.ExitCode | Should -Be 0
        $result.Output | Should -Match 'node_modules'
    }

    It 'returns config as JSON with accessible properties' {
        if (-not $script:available) {
            Set-ItResult -Skipped -Because 'tool_node_missing'; return
        }
        $result = Invoke-Npm 'config list --json' -PassThru -Silent
        $result.ExitCode | Should -Be 0
        $config = $result.Output | ConvertFrom-Json
        $config.prefix | Should -Not -BeNullOrEmpty
    }
}
