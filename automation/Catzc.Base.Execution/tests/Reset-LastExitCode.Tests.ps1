<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.Execution/tests/Reset-LastExitCode.Tests.ps1
    folder: tests
    name: reset-last-exit-code-tests
    filetype: ps1
    kind: test
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.Execution
    moduletype: pwsh-folder
    catzc_bundle: azure
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
