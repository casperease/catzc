<#
---
catzc:
  immutable:
    path: automation/Catzc.Base.Files/tests/Set-InputStamp.Tests.ps1
    folder: tests
    name: set-input-stamp-tests
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

Describe 'Set-InputStamp' -Tag 'L0', 'logic' {
    BeforeEach {
        $script:root = Join-Path (Get-Item $TestDrive).FullName ([guid]::NewGuid().ToString('N'))
        Mock Get-OutputRoot { $script:root } -ModuleName Catzc.Base.Files
        $script:stored = Join-Path $script:root '.stamps/widget.stamp'
    }

    It 'writes the stamp under the output root and reports changed' {
        Set-InputStamp widget 'abc' | Should -BeTrue
        [System.IO.File]::ReadAllText($stored).Trim() | Should -BeExactly 'abc'
    }

    It 'reports unchanged when the same stamp is already stored' {
        Set-InputStamp widget 'abc' | Out-Null
        Set-InputStamp widget 'abc' | Should -BeFalse
    }

    It 'replaces a different stored stamp' {
        Set-InputStamp widget 'abc' | Out-Null
        Set-InputStamp widget 'abd' | Should -BeTrue
        [System.IO.File]::ReadAllText($stored).Trim() | Should -BeExactly 'abd'
    }

    It '-DryRun reports a would-be change without writing' {
        Set-InputStamp widget 'abc' -DryRun | Should -BeTrue
        [System.IO.File]::Exists($stored) | Should -BeFalse
    }

    It 'rejects a name that is not a plain file name' {
        { Set-InputStamp 'a/b' 'abc' } | Should -Throw
    }
}
