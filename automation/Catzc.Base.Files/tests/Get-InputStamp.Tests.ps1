<#
---
catzc:
  immutable:
    path: automation/Catzc.Base.Files/tests/Get-InputStamp.Tests.ps1
    folder: tests
    name: get-input-stamp-tests
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

Describe 'Get-InputStamp' -Tag 'L0', 'logic' {
    BeforeEach {
        $script:widget = Join-Path $TestDrive 'widget.txt'
        $script:gadgets = Join-Path $TestDrive 'gadgets'
        [System.IO.Directory]::CreateDirectory((Join-Path $gadgets 'deep')) | Out-Null
        [System.IO.File]::WriteAllText($widget, 'one')
        [System.IO.File]::WriteAllText((Join-Path $gadgets 'a.md'), 'a')
        [System.IO.File]::WriteAllText((Join-Path $gadgets 'deep/b.txt'), 'b')
    }

    It 'returns a 64-character lowercase hex string' {
        Get-InputStamp $widget | Should -MatchExactly '^[0-9a-f]{64}$'
    }

    It 'is stable across calls and across path order' {
        $first = Get-InputStamp $widget, $gadgets
        Get-InputStamp $gadgets, $widget | Should -BeExactly $first
        Get-InputStamp $widget, $gadgets | Should -BeExactly $first
    }

    It 'changes when a file changes length' {
        $before = Get-InputStamp $widget
        [System.IO.File]::WriteAllText($widget, 'one two')
        Get-InputStamp $widget | Should -Not -BeExactly $before
    }

    It 'changes when a file is touched without a content change' {
        $before = Get-InputStamp $widget
        [System.IO.File]::SetLastWriteTimeUtc($widget, [datetime]::UtcNow.AddHours(-3))
        Get-InputStamp $widget | Should -Not -BeExactly $before
    }

    It 'includes files below a folder, recursively' {
        $before = Get-InputStamp $gadgets
        [System.IO.File]::WriteAllText((Join-Path $gadgets 'deep/c.txt'), 'c')
        Get-InputStamp $gadgets | Should -Not -BeExactly $before
    }

    It '-Filter narrows a folder to the matching names' {
        $before = Get-InputStamp $gadgets -Filter '*.md'
        [System.IO.File]::WriteAllText((Join-Path $gadgets 'deep/c.txt'), 'c')
        Get-InputStamp $gadgets -Filter '*.md' | Should -BeExactly $before
        [System.IO.File]::WriteAllText((Join-Path $gadgets 'd.md'), 'd')
        Get-InputStamp $gadgets -Filter '*.md' | Should -Not -BeExactly $before
    }

    It 'a missing path stamps differently from a present one, and a deleted input changes the stamp' {
        $before = Get-InputStamp $widget
        Remove-Item $widget
        Get-InputStamp $widget | Should -Not -BeExactly $before
    }

    It '-Salt is folded into the stamp' {
        Get-InputStamp $widget -Salt 'x' | Should -Not -BeExactly (Get-InputStamp $widget -Salt 'y')
    }
}
