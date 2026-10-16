<#
---
catzc:
  immutable:
    path: automation/Catzc.Base.Asserts/tests/Assert-LastExitCodeWasZero.Tests.ps1
    folder: tests
    name: assert-last-exit-code-was-zero-tests
    filetype: ps1
    kind: test
    language: powershell
    track: automation
    module: Catzc.Base.Asserts
    moduletype: pwsh-folder
    catzc_bundle: minimal
---
#>

Describe 'Assert-LastExitCodeWasZero' -Tag 'L0', 'logic' {
    It 'passes when LASTEXITCODE is 0' {
        $global:LASTEXITCODE = 0
        { Assert-LastExitCodeWasZero } | Should -Not -Throw
    }

    It 'throws when LASTEXITCODE is non-zero' {
        $global:LASTEXITCODE = 1
        { Assert-LastExitCodeWasZero } | Should -Throw
    }

    It 'resets LASTEXITCODE by default' {
        $global:LASTEXITCODE = 0
        Assert-LastExitCodeWasZero
        Get-Variable LASTEXITCODE -Scope Global -ErrorAction Ignore | Should -BeNullOrEmpty
    }

    It 'preserves LASTEXITCODE with -DoNotReset' {
        $global:LASTEXITCODE = 0
        Assert-LastExitCodeWasZero -DoNotReset
        $global:LASTEXITCODE | Should -Be 0
    }
}
