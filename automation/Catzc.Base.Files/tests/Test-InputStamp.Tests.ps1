<#
---
catzc:
  immutable:
    path: automation/Catzc.Base.Files/tests/Test-InputStamp.Tests.ps1
    folder: tests
    name: test-input-stamp-tests
    filetype: ps1
    kind: test
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.Files
    moduletype: pwsh-folder
    catzc_bundle: azure
---
#>

Describe 'Test-InputStamp' -Tag 'L0', 'logic' {
    BeforeEach {
        $script:root = Join-Path (Get-Item $TestDrive).FullName ([guid]::NewGuid().ToString('N'))
        Mock Get-OutputRoot { $script:root } -ModuleName Catzc.Base.Files
    }

    It 'is not current when nothing is stored' {
        Test-InputStamp widget 'abc' | Should -BeFalse
    }

    It 'is current when the stored stamp equals the given one' {
        Set-InputStamp widget 'abc' | Out-Null
        Test-InputStamp widget 'abc' | Should -BeTrue
    }

    It 'is not current when the stored stamp differs' {
        Set-InputStamp widget 'abc' | Out-Null
        Test-InputStamp widget 'abd' | Should -BeFalse
    }

    It 'keeps stamps apart by name' {
        Set-InputStamp widget 'abc' | Out-Null
        Test-InputStamp gadget 'abc' | Should -BeFalse
    }

    It 'rejects a name that is not a plain file name' {
        { Test-InputStamp '../widget' 'abc' } | Should -Throw
    }
}
