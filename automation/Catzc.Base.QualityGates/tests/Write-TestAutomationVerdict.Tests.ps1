[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidGlobalVars', '', Justification = 'Tests lift $global:__PesterRunning to verify writer output; that flag is the writers'' test-suppression interface, set by Test-Automation')]
param()

Describe 'Write-TestAutomationVerdict' -Tag 'L0', 'logic', 'ADR-CONSOLE#7' {
    # The writers' chokepoint returns early during a run ($global:__PesterRunning); lift it so the banner's
    # information-stream output can be asserted (see console-output-matters / Write-InformationColored).
    BeforeAll {
        $global:__PesterRunning = $false

        function StripAnsi {
            param([string] $Text)
            $Text -replace "`e\[[0-9;]*m", ''
        }

        # The presenter is a private (module-scoped) function, so it is invoked through InModuleScope
        # (ADR-PESTER:4). Returns the RAW banner (ANSI intact) so a caller can assert on colour or strip for text.
        function Get-VerdictRaw {
            param($Result, $Summary, $PassedCount = 0, $FailedCount = 0, $SkippedCount = 0, $DurationSeconds = 0)
            InModuleScope Catzc.Base.QualityGates -Parameters @{ R = $Result; S = $Summary; P = $PassedCount; F = $FailedCount; K = $SkippedCount; D = $DurationSeconds } {
                param($R, $S, $P, $F, $K, $D)
                Write-TestAutomationVerdict -Result $R -Summary $S -PassedCount $P -FailedCount $F -SkippedCount $K -DurationSeconds $D `
                    -InformationVariable iv -InformationAction SilentlyContinue 6>&1 | Out-Null
                ($iv | ForEach-Object { [string]$_.MessageData }) -join "`n"
            }
        }
    }

    AfterAll { $global:__PesterRunning = $true }

    It 'closes a passing run with a green-rainbow banner and the summary' {
        $raw = Get-VerdictRaw -Result 'Passed' -Summary '812 passed, 14 skipped in 42.3s' -PassedCount 812 -SkippedCount 14 -DurationSeconds 42.3
        $plain = StripAnsi $raw
        $plain | Should -Match 'Test Automation PASSED — 812 passed, 14 skipped in 42\.3s'
        $plain | Should -Match '812 passed · 14 skipped · 0 failed'

        # The title line carries the green base (92); the rule lines are a multi-colour gradient (>3 SGR codes).
        $raw | Should -Match '\e\[92m│ Test Automation PASSED'
        $codes = [regex]::Matches($raw, '\e\[(\d+)m') | ForEach-Object { $_.Groups[1].Value } |
            Where-Object { $_ -ne '0' } | Select-Object -Unique
        @($codes).Count | Should -BeGreaterThan 3
    }

    It 'closes a failing run with a red-rainbow banner anchored on red' {
        $raw = Get-VerdictRaw -Result 'Failed' -Summary '3 test(s) failed' -PassedCount 809 -FailedCount 3 -SkippedCount 14 -DurationSeconds 42.3
        $plain = StripAnsi $raw
        $plain | Should -Match 'Test Automation FAILED — 3 test\(s\) failed'
        $plain | Should -Match '809 passed · 14 skipped · 3 failed'
        $raw | Should -Match '\e\[91m│ Test Automation FAILED'   # red base title
    }

    It 'ends on a closing footer rule, not the counts line (the bracket is closed)' {
        $raw = Get-VerdictRaw -Result 'Passed' -Summary 'x' -PassedCount 1
        $lines = (StripAnsi $raw) -split "`n" | Where-Object { $_ -ne '' }
        $lines[-1] | Should -Match '^╰─+╯$'
    }

    It 'rejects a verdict outside the two expected values (fail-fast at binding)' {
        {
            InModuleScope Catzc.Base.QualityGates {
                Write-TestAutomationVerdict -Result 'Maybe' -Summary 'x'
            }
        } | Should -Throw
    }

    It 'stays silent under the harness suppression flag' {
        $global:__PesterRunning = $true
        try {
            Get-VerdictRaw -Result 'Passed' -Summary 'x' -PassedCount 1 | Should -BeNullOrEmpty
        }
        finally {
            $global:__PesterRunning = $false
        }
    }
}
