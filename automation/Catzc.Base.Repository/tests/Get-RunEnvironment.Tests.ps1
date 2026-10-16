<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Repository/tests/Get-RunEnvironment.Tests.ps1
    kind: test
    language: powershell
    filetype: ps1
    track: automation
    module: Catzc.Base.Repository
    moduletype: pwsh-folder-module
    bundle: azure
---
#>

Describe 'Get-RunEnvironment' -Tag 'L0', 'logic' {
    It 'is a devbox outside a pipeline' {
        Mock Test-IsRunningInPipeline { $false } -ModuleName Catzc.Base.Repository
        Get-RunEnvironment | Should -Be 'Devbox'
    }

    It 'is a pipeline inside one' {
        Mock Test-IsRunningInPipeline { $true } -ModuleName Catzc.Base.Repository
        Get-RunEnvironment | Should -Be 'Pipeline'
    }

    It 'returns the environment when -EnvironmentAssertIs matches it' {
        Mock Test-IsRunningInPipeline { $true } -ModuleName Catzc.Base.Repository
        Get-RunEnvironment -EnvironmentAssertIs Pipeline | Should -Be 'Pipeline'
    }

    It 'throws naming both environments when -EnvironmentAssertIs differs' {
        Mock Test-IsRunningInPipeline { $false } -ModuleName Catzc.Base.Repository
        { Get-RunEnvironment -EnvironmentAssertIs Pipeline } | Should -Throw "*'Devbox'*'Pipeline'*"
    }
}
