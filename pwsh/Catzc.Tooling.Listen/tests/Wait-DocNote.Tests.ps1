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

    It 'returns nothing when its bound runs out with every note processed' {
        Write-ListenFixtureFile 'docs/adr/widget.md' "# Widget`n`nProcessed.`n"
        Get-DocChange -Session $script:session | New-DocNote -Session $script:session | Out-Null
        Complete-DocNote -Session $script:session -Id '0001' -FactCheck 'holds' -Pattern 'widget' -Plan 'none'
        $watch = [System.Diagnostics.Stopwatch]::StartNew()
        @(Wait-DocNote -Session $script:session -TimeoutSeconds 1).Count | Should -Be 0
        $watch.Elapsed.TotalSeconds | Should -BeLessThan 3
    }
}
