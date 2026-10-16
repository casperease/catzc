<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Execution/tests/Reset-LastExitCode.Tests.ps1
    kind: test
    language: powershell
    filekind: ps1
    track: automation
    module: Catzc.Base.Execution
    relatives:
      source: automation/Catzc.Base.Execution/Reset-LastExitCode.ps1
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
