<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Execution/tests/Reset-LastExitCode.Tests.ps1
    kind: test
    language: powershell
    filetype: ps1
    track: automation
    module: Catzc.Base.Execution
    moduletype: pwsh-folder-module
    bundle: azure
---
#>

Describe 'Reset-LastExitCode' -Tag 'L0', 'logic' {
    It 'removes LASTEXITCODE when it exists' {
        $global:LASTEXITCODE = 42
        Reset-LastExitCode
        Get-Variable LASTEXITCODE -Scope Global -ErrorAction Ignore | Should -BeNullOrEmpty
    }

    It 'does not throw when LASTEXITCODE does not exist' {
        Remove-Variable LASTEXITCODE -Scope Global -ErrorAction Ignore
        { Reset-LastExitCode } | Should -Not -Throw
    }
}
