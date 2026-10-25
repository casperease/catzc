# One finding per breach, each with path:line, the limit and where the limit came from, so a reader goes straight to the line.
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

    It 'reports nothing for a file within its limits' {
        @(Test-FileShape -Path $script:fine).Count | Should -Be 0
    }
}
