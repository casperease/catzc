<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Engines/tests/Get-ExecutionEngine.Tests.ps1
    folder: tests
    name: get-execution-engine-tests
    filetype: ps1
    kind: test
    language: powershell
    track: automation
    module: Catzc.Base.Engines
    moduletype: pwsh-folder
    catzc_bundle: azure
---
#>

Describe 'Get-ExecutionEngine' -Tag 'L0', 'logic' {
    It 'returns every engine, pwsh first, when no name is given' {
        @(Get-ExecutionEngine).Name | Should -Be @('pwsh', 'bash', 'zsh')
    }

    It 'returns the engine of that name' {
        (Get-ExecutionEngine -Name bash).ImporterEntry | Should -Be 'importer.sh'
        (Get-ExecutionEngine -Name zsh).ImporterEntry | Should -Be 'importer.sh'
    }

    It 'throws, naming the engines, for an unknown name' {
        { Get-ExecutionEngine -Name widget } | Should -Throw '*one of: pwsh, bash, zsh*'
    }
}
