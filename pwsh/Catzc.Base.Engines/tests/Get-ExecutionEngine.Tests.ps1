<#
---
catzc:
  immutable:
    with_body_sha: a0e1b354356c
  edges:
    code: pwsh/Catzc.Base.Engines/Get-ExecutionEngine.ps1
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
