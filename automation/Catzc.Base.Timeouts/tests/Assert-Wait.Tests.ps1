<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.Timeouts/tests/Assert-Wait.Tests.ps1
    folder: tests
    name: assert-wait-tests
    filetype: ps1
    kind: test
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.Timeouts
    moduletype: pwsh-folder
    catzc_bundle: azure
---
#>

[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidGlobalVars', '', Justification = 'Tests lift $global:__PesterRunning to verify writer output; that flag is the writers'' test-suppression interface, set by Test-Automation')]
param()

# The contract these tests pin is the one in .claude/plans/plan-assert-wait.md (Q1-Q3 confirm the reading).
Describe 'Assert-Wait' -Tag 'L0', 'logic' {
    # The chokepoint guard returns early during a run ($global:__PesterRunning); lift it so output can be asserted.
    BeforeAll {
        $global:__PesterRunning = $false

        # Runs Assert-Wait with its sleeping replaced, and returns the written lines in order. -SleepMs 0 makes every tick instant.
        function Get-WaitLine {
            param([hashtable] $Arguments = @{}, [int] $SleepMs = 0)

            $sleepMilliseconds = $SleepMs
            Mock Start-Sleep -ModuleName Catzc.Base.Timeouts -MockWith {
                if ($sleepMilliseconds -gt 0) {
                    Microsoft.PowerShell.Utility\Start-Sleep -Milliseconds $sleepMilliseconds
                }
            }.GetNewClosure()
            Assert-Wait @Arguments -InformationVariable iv -InformationAction SilentlyContinue
            @($iv | ForEach-Object { if ($_.MessageData -is [string]) {
                        $_.MessageData
                    }
                    else {
                        $_.MessageData.Message
                    } })
        }
    }
    AfterAll { $global:__PesterRunning = $true }

    Context 'duration' {
        It 'defaults to 1.001 seconds' {
            $lines = Get-WaitLine
            $lines[0] | Should -BeLike '*1.001 s*'
        }

        It 'adds Milliseconds to Seconds' {
            $lines = Get-WaitLine @{ Seconds = 2; Milliseconds = 250 }
            $lines[0] | Should -BeLike '*2.250 s*'
        }

        It 'accepts Milliseconds alone' {
            $lines = Get-WaitLine @{ Seconds = 0; Milliseconds = 30 }
            $lines[0] | Should -BeLike '*0.030 s*'
        }

        It 'sleeps the total in ten equal ticks' {
            $null = Get-WaitLine @{ Seconds = 0; Milliseconds = 100 }
            Should -Invoke Start-Sleep -ModuleName Catzc.Base.Timeouts -Times 10 -Exactly -ParameterFilter { $Milliseconds -eq 10 }
        }
    }

    Context 'output' {
        It 'writes the opening line, ten ticks, then exactly one closing line, last' {
            $lines = Get-WaitLine @{ Seconds = 0; Milliseconds = 30 }
            $lines.Count | Should -Be 12
            $lines[0] | Should -BeLike '*standing at*'
            @($lines | Where-Object { $_ -like '*tick */10:*' }).Count | Should -Be 10
            $lines[-1] | Should -BeLike '*waited*'
            @($lines | Where-Object { $_ -like '*waited*' }).Count | Should -Be 1
        }

        It 'numbers its ticks of ten' {
            $lines = Get-WaitLine @{ Seconds = 0; Milliseconds = 30 }
            $lines[1] | Should -BeLike '*tick 1/10*'
            $lines[10] | Should -BeLike '*tick 10/10*'
        }

        It 'names the place it stands, as file and line' {
            $lines = Get-WaitLine @{ Seconds = 0; Milliseconds = 30 }
            $lines[0] | Should -Match 'Assert-Wait.Tests.ps1:\d+|Get-WaitLine'
        }

        It 'writes the closing line yellow, as a warning line' {
            $lines = Get-WaitLine @{ Seconds = 0; Milliseconds = 30 }
            # StartsWith, not -like: the escape sequence holds '[', a wildcard character.
            $lines[-1].StartsWith([Catzc.Base.Writers.Ansi]::Code([System.ConsoleColor]::Yellow)) | Should -BeTrue
        }

        It 'tells the reader to remove the watchpoint once the block is bounded' {
            $lines = Get-WaitLine @{ Seconds = 0; Milliseconds = 30 }
            $lines[-1] | Should -BeLike '*remove this watchpoint*'
        }

        It 'always warns, even when nothing was late' {
            $lines = Get-WaitLine @{ Seconds = 0; Milliseconds = 30 } -SleepMs 0
            $lines[-1] | Should -BeLike '*waited*'
        }
    }

    Context 'letting go' {
        It 'does not terminate when WarningPreference is Stop' {
            $previous = $WarningPreference
            $WarningPreference = 'Stop'
            try {
                { Assert-Wait -Seconds 0 -Milliseconds 30 -InformationAction SilentlyContinue } | Should -Not -Throw
            }
            finally {
                $WarningPreference = $previous
            }
        }

        It 'returns nothing' {
            Mock Start-Sleep -ModuleName Catzc.Base.Timeouts { }
            Assert-Wait -Seconds 0 -Milliseconds 30 -InformationAction SilentlyContinue | Should -BeNullOrEmpty
        }

        It 'reports a late tick and still lets go, without throwing' {
            # Each tick is due about 1 ms apart but the sleep takes 20 ms: the thread was not running on schedule.
            $lines = Get-WaitLine @{ Seconds = 0; Milliseconds = 10 } -SleepMs 20
            ($lines[-1] -match 'worst tick late (\d+) ms') | Should -BeTrue
            [int] $Matches[1] | Should -BeGreaterThan 10
        }
    }

    Context 'invalid arguments' {
        It 'throws for a total of zero, with the assertion message' {
            { Assert-Wait -Seconds 0 -Milliseconds 0 } | Should -Throw
        }

        It 'throws for a negative Seconds' {
            { Assert-Wait -Seconds -1 } | Should -Throw
        }

        It 'throws for a negative Milliseconds' {
            { Assert-Wait -Milliseconds -1 } | Should -Throw
        }
    }
}
