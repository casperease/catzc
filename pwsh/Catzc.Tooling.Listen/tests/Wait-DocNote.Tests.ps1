Describe 'Wait-DocNote' -Tag 'L0', 'logic', 'ADR-AUTO-FAILFAST-BOUNDEVERYWAIT' {
    BeforeAll {
        . (Join-Path $PSScriptRoot 'Listen.Fixture.ps1')
        Register-ListenFixtureMocks
    }

    BeforeEach {
        Initialize-ListenFixture | Out-Null
        $script:session = (New-DocSnapshot).Path
    }

    It 'returns the backlog at once' {
        Write-ListenFixtureFile 'docs/adr/widget.md' "# Widget`n`nBacklog.`n"
        Get-DocChange -Session $script:session | New-DocNote -Session $script:session | Out-Null
        @(Wait-DocNote -Session $script:session -TimeoutSeconds 1).Id | Should -Be @('0001')
    }

    It 'waits only for notes from the named writers' {
        Write-ListenFixtureFile 'docs/adr/widget.md' "# Widget`n`nNo ledger knows this.`n"
        Get-DocChange -Session $script:session | New-DocNote -Session $script:session | Out-Null
        @(Wait-DocNote -Session $script:session -Source editor -TimeoutSeconds 1).Count | Should -Be 0
        @(Wait-DocNote -Session $script:session -Source unknown -TimeoutSeconds 1).Id | Should -Be @('0001')
    }

    It 'waits, instead of throwing, while there is no session yet' {
        Initialize-ListenFixture | Out-Null
        @(Wait-DocNote -TimeoutSeconds 1).Count | Should -Be 0
    }

    It 'follows the newest session, so a listener started after a wipe is picked up' {
        [System.IO.Directory]::Delete($script:session, $true)
        $script:session = (New-DocSnapshot).Path
        Write-ListenFixtureFile 'docs/adr/widget.md' "# Widget`n`nAfter the wipe.`n"
        Get-DocChange -Session $script:session | New-DocNote -Session $script:session | Out-Null
        $notes = @(Wait-DocNote -TimeoutSeconds 1)
        @($notes.Id) | Should -Be @('0001')
        $notes[0].Session | Should -BeExactly $script:session
    }

    It 'returns nothing, instead of throwing, when a named session has vanished' {
        [System.IO.Directory]::Delete($script:session, $true)
        @(Wait-DocNote -Session $script:session -TimeoutSeconds 1).Count | Should -Be 0
    }

    It 'returns nothing when its bound runs out with every note processed' {
        Write-ListenFixtureFile 'docs/adr/widget.md' "# Widget`n`nProcessed.`n"
        Get-DocChange -Session $script:session | New-DocNote -Session $script:session | Out-Null
        Complete-DocNote -Session $script:session -Id '0001' -FactCheck 'holds' -FactCheckReason 'docs/adr/widget.md:3 already says it' -Pattern 'widget' -Plan 'none'
        $watch = [System.Diagnostics.Stopwatch]::StartNew()
        @(Wait-DocNote -Session $script:session -TimeoutSeconds 1).Count | Should -Be 0
        $watch.Elapsed.TotalSeconds | Should -BeLessThan 3
    }
}
