Describe 'Start-DocListener' -Tag 'L0', 'logic' {
    BeforeAll {
        . (Join-Path $PSScriptRoot 'Listen.Fixture.ps1')
        Register-ListenFixtureMocks
    }

    BeforeEach {
        Initialize-ListenFixture | Out-Null
        $script:session = (New-DocSnapshot).Path
    }

    It 'notes every settled change once and moves seen forward' {
        Write-ListenFixtureFile 'docs/adr/widget.md' "# Widget`n`nNoted.`n"
        Start-DocListener -Session $script:session -Cycles 1
        @(Get-DocNote -Session $script:session).File | Should -Be @('docs/adr/widget.md')
        @(Get-DocChange -Session $script:session).Count | Should -Be 0

        Write-ListenFixtureFile 'docs/explanation/gadget.md' "# Gadget`n`nNoted next.`n"
        Start-DocListener -Session $script:session -Cycles 1
        @((Get-DocNote -Session $script:session).File) | Should -Be @('docs/adr/widget.md', 'docs/explanation/gadget.md')
    }

    It 'moves both sides of a rename forward' {
        $old = Join-Path $script:root 'docs/explanation/gadget.md'
        Write-ListenFixtureFile 'docs/explanation/gadget-turns.md' ([System.IO.File]::ReadAllText($old))
        [System.IO.File]::Delete($old)
        Start-DocListener -Session $script:session -Cycles 1
        (Get-DocNote -Session $script:session).Change | Should -BeExactly 'renamed'
        @(Get-DocChange -Session $script:session).Count | Should -Be 0
    }

    It 'starts a new session when none is named' {
        Initialize-ListenFixture | Out-Null
        Mock Wait-DocChange -ModuleName Catzc.Tooling.Listen { }
        Start-DocListener -Cycles 1
        @([System.IO.Directory]::GetDirectories((Join-Path $script:root 'out/listen'))).Count | Should -Be 1
    }
}
