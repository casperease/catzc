Describe 'Complete-DocNote' -Tag 'L0', 'logic' {
    BeforeAll {
        . (Join-Path $PSScriptRoot 'Listen.Fixture.ps1')
        Register-ListenFixtureMocks
    }

    BeforeEach {
        Initialize-ListenFixture | Out-Null
        $script:session = (New-DocSnapshot).Path
        Write-ListenFixtureFile 'docs/adr/widget.md' "# Widget`n`nCompleted.`n"
        Get-DocChange -Session $script:session | New-DocNote -Session $script:session | Out-Null
    }

    It 'appends one ledger line and leaves the note untouched' {
        $before = [System.IO.File]::ReadAllText((Join-Path $script:session 'notes/0001.md'))
        Complete-DocNote -Session $script:session -Id '0001' -FactCheck 'does not hold' -Pattern 'widget-parts' -Plan 'plan-listen-widget-parts.md'
        [System.IO.File]::ReadAllText((Join-Path $script:session 'processed.md')) |
            Should -BeExactly "- 0001 | fact-check: does not hold | pattern: widget-parts | plan: plan-listen-widget-parts.md`n"
        [System.IO.File]::ReadAllText((Join-Path $script:session 'notes/0001.md')) | Should -BeExactly $before
    }

    It 'throws on an unknown note' {
        { Complete-DocNote -Session $script:session -Id '0009' -FactCheck 'holds' -Pattern 'widget' -Plan 'none' } | Should -Throw "*has no note '0009'*"
    }

    It 'throws on a note completed before' {
        Complete-DocNote -Session $script:session -Id '0001' -FactCheck 'holds' -Pattern 'widget' -Plan 'none'
        { Complete-DocNote -Session $script:session -Id '0001' -FactCheck 'holds' -Pattern 'widget' -Plan 'none' } | Should -Throw '*already processed*'
    }

    It 'throws on a value the ledger line cannot carry' {
        { Complete-DocNote -Session $script:session -Id '0001' -FactCheck 'holds' -Pattern 'widget | gadget' -Plan 'none' } | Should -Throw "*holds a '|'*"
    }
}
