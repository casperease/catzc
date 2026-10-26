<#
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-file-limits/tests/Test-FileShape.Tests.ps1.md"
  header: "generated"
---
#>

# One finding per breach, with path:line, the limit and its source, so a reader goes straight to the line.
Describe 'Test-FileShape' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:wide = Join-Path $TestDrive 'widget.ps1'
        [System.IO.File]::WriteAllText($script:wide, "a`n" + ('x' * 130) + "`n")
        $script:fine = Join-Path $TestDrive 'gadget.ps1'
        [System.IO.File]::WriteAllText($script:fine, "a`n")
    }

    It 'reports a width breach at the widest line' {
        $finding = @(Test-FileShape -Path $script:wide)
        $finding.Count | Should -Be 1
        $finding[0].Check | Should -Be 'width'
        $finding[0].Line | Should -Be 2
        $finding[0].Message | Should -BeLike '*:2 is 130 wide*'
    }

    It 'reports a length breach at the last line' {
        $long = Join-Path $TestDrive 'long.ps1'
        [System.IO.File]::WriteAllLines($long, [string[]](1..401 | ForEach-Object { 'a' }))
        $finding = @(Test-FileShape -Path $long)
        $finding.Check | Should -Be 'length'
        $finding.Line | Should -Be 401
    }

    It 'passes a line whose overflow lies wholly inside one string literal, and reports the widest line that is not one' {
        $strung = Join-Path $TestDrive 'strung.ps1'
        $message = 'w' * 140
        [System.IO.File]::WriteAllText($strung, "`$a = '$message'`n`$b = 1 + 2`n")
        @(Test-FileShape -Path $strung).Count | Should -Be 0
        [System.IO.File]::WriteAllText($strung, "`$a = '$message'`n" + ('x' * 125) + "`n")
        $finding = @(Test-FileShape -Path $strung)
        $finding.Line | Should -Be 2
        $finding.Value | Should -Be 125
    }

    It 'reports nothing for a file within its limits' {
        @(Test-FileShape -Path $script:fine).Count | Should -Be 0
    }
}
