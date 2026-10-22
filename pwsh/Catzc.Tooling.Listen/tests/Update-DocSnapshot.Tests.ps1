Describe 'Update-DocSnapshot' -Tag 'L0', 'logic' {
    BeforeAll {
        . (Join-Path $PSScriptRoot 'Listen.Fixture.ps1')
        Register-ListenFixtureMocks
    }

    BeforeEach {
        Initialize-ListenFixture | Out-Null
        $script:session = (New-DocSnapshot).Path
    }

    It 'moves seen forward for a changed file and leaves the baseline as it was' {
        Write-ListenFixtureFile 'docs/drs/widget.md' "# Widget`n`nMoved on.`n"
        Update-DocSnapshot -Session $script:session -Path 'docs/drs/widget.md'
        @(Get-DocChange -Session $script:session).Count | Should -Be 0
        [System.IO.File]::ReadAllText((Join-Path $script:session 'seen/drs/widget.md')) | Should -BeLike '*Moved on.*'
        [System.IO.File]::ReadAllText((Join-Path $script:session 'baseline/drs/widget.md')) | Should -BeLike '*widget rule*'
    }

    It 'removes a deleted file from seen and its index' {
        [System.IO.File]::Delete((Join-Path $script:root 'docs/explanation/gadget.md'))
        Update-DocSnapshot -Session $script:session -Path 'docs/explanation/gadget.md'
        [System.IO.File]::Exists((Join-Path $script:session 'seen/explanation/gadget.md')) | Should -BeFalse
        $index = [System.IO.File]::ReadAllText((Join-Path $script:session 'seen.json')) | ConvertFrom-Json -AsHashtable
        $index.ContainsKey('docs/explanation/gadget.md') | Should -BeFalse
        @(Get-DocChange -Session $script:session).Count | Should -Be 0
    }

    It 'throws on a path outside the watched folder' {
        { Update-DocSnapshot -Session $script:session -Path 'gizmo/widget.ps1' } | Should -Throw "*not under the watched folder 'docs'*"
    }
}
