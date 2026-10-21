<#
---
catzc:
  immutable:
    with_body_sha: "9e97b1313d7a"
  edges:
    code: pwsh/Catzc.Tooling.Listen/Wait-DocChange.ps1
    cites:
      - ADR-AUTO-FAILFAST-BOUNDEVERYWAIT
---
#>

Describe 'Wait-DocChange' -Tag 'L0', 'logic', 'ADR-AUTO-FAILFAST-BOUNDEVERYWAIT' {
    BeforeAll {
        . (Join-Path $PSScriptRoot 'Listen.Fixture.ps1')
        Register-ListenFixtureMocks
    }

    BeforeEach {
        Initialize-ListenFixture | Out-Null
        $script:session = (New-DocSnapshot).Path
    }

    It 'returns a change once it has settled' {
        Write-ListenFixtureFile 'docs/adr/widget.md' "# Widget`n`nSettled.`n"
        $changes = @(Wait-DocChange -Session $script:session -TimeoutSeconds 5)
        @($changes.Path) | Should -Be @('docs/adr/widget.md')
    }

    It 'returns nothing when its bound runs out with no change' {
        $watch = [System.Diagnostics.Stopwatch]::StartNew()
        @(Wait-DocChange -Session $script:session -TimeoutSeconds 1).Count | Should -Be 0
        $watch.Elapsed.TotalSeconds | Should -BeLessThan 3
    }

    It 'waits out the quiet window before it returns' {
        $script:config = [Catzc.Tooling.Listen.ListenConfig]::new([ordered]@{ poll_milliseconds = 100; quiet_seconds = 1 })
        Write-ListenFixtureFile 'docs/adr/widget.md' "# Widget`n`nQuiet.`n"
        $watch = [System.Diagnostics.Stopwatch]::StartNew()
        @(Wait-DocChange -Session $script:session -TimeoutSeconds 5).Count | Should -Be 1
        $watch.Elapsed.TotalSeconds | Should -BeGreaterOrEqual 1
    }
}
