<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Execution/tests/Get-LastExitCode.Tests.ps1
    kind: test
    language: powershell
    filekind: ps1
    track: automation
    module: Catzc.Base.Execution
    relatives:
      source: automation/Catzc.Base.Execution/Get-LastExitCode.ps1
---
#>

Describe 'Get-LastExitCode' -Tag 'L0', 'logic' {
    It 'returns the exit code value' {
        $global:LASTEXITCODE = 42
        Get-LastExitCode | Should -Be 42
    }

    It 'returns nothing when no exit code exists' {
        Remove-Variable LASTEXITCODE -Scope Global -ErrorAction Ignore
        Get-LastExitCode | Should -BeNullOrEmpty
    }
}
