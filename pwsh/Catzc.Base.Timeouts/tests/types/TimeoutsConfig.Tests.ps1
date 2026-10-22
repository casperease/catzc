<#
---
catzc:
  immutable:
    with_body_sha: b0cf64018f70
  edges:
    code: pwsh/Catzc.Base.Timeouts/types/TimeoutsConfig.cs
    cites:
      - ADR-AUTO-DEFAULT-ONERESOLUTIONORDER
      - ADR-AUTO-FAILFAST-BOUNDEVERYWAIT
      - ADR-PWSH-ASSERT-DECLAREDTIMELIMIT
---
#>

Describe 'TimeoutsConfig' -Tag 'L0' {

    Context 'integrity (shipped timeouts.yml)' -Tag 'integrity' {
        It 'passes for the shipped timeouts.yml' {
            Get-Config -Config timeouts | Should -BeOfType [Catzc.Base.Timeouts.TimeoutsConfig]
        }
    }

    Context 'logic (fixture configs)' -Tag 'logic' {
        BeforeAll {
            function script:New-TimeoutsConfig {
                param([System.Collections.IDictionary] $Data)
                [Catzc.Base.Timeouts.TimeoutsConfig]::new($Data)
            }
        }

        It 'resolves the sensible defaults for every environment and shell from an empty config' {
            $config = New-TimeoutsConfig ([ordered]@{})
            $config.SecondsFor('Devbox', 'Bash', $false) | Should -Be 3
            $config.SecondsFor('Devbox', 'Bash', $true) | Should -Be 360
            $config.SecondsFor('Devbox', 'Pwsh', $false) | Should -Be 3
            $config.SecondsFor('Pipeline', 'Bash', $false) | Should -Be 600
            $config.SecondsFor('Pipeline', 'Bash', $true) | Should -Be 3600
            $config.SecondsFor('Pipeline', 'Pwsh', $false) | Should -Be 600
            $config.executables.Count | Should -Be 0
        }

        It 'gives zsh one limit per environment, the pwsh-side defaults, tunable on its own' {
            $config = New-TimeoutsConfig ([ordered]@{ limits = @{ pipeline = @{ zsh = 900 } } })
            $config.SecondsFor('Devbox', 'Zsh', $false) | Should -Be 3
            $config.SecondsFor('Pipeline', 'zsh', $false) | Should -Be 900
            $config.SecondsFor('Pipeline', 'Pwsh', $false) | Should -Be 600
            $config.limits.pipeline.zsh | Should -Be 900
            { $config.SecondsFor('Devbox', 'zsh', $true) } | Should -Throw '*zsh has no background limit*'
            { New-TimeoutsConfig ([ordered]@{ limits = @{ devbox = @{ zsh = 0 } } }) } | Should -Throw "*invalid limits.devbox.zsh '0'*"
        }

        It 'resolves the defaults from a null config' {
            (New-TimeoutsConfig $null).SecondsFor('devbox', 'bash', $false) | Should -Be 3
        }

        It 'overrides one cell and keeps the defaults of the others' {
            $config = New-TimeoutsConfig ([ordered]@{ limits = @{ devbox = @{ bash = @{ foreground = 15 } } } })
            $config.SecondsFor('Devbox', 'Bash', $false) | Should -Be 15
            $config.SecondsFor('Devbox', 'Bash', $true) | Should -Be 360
            $config.SecondsFor('Devbox', 'Pwsh', $false) | Should -Be 3
            $config.SecondsFor('Pipeline', 'Bash', $false) | Should -Be 600
        }

        It 'exposes the resolved limits, defaults filled in' {
            $config = New-TimeoutsConfig ([ordered]@{ limits = @{ pipeline = @{ pwsh = 900 } } })
            $config.limits.pipeline.pwsh | Should -Be 900
            $config.limits.devbox.bash.background | Should -Be 360
        }

        It 'throws on a background limit for pwsh' {
            { (New-TimeoutsConfig ([ordered]@{})).SecondsFor('Devbox', 'Pwsh', $true) } | Should -Throw '*pwsh has no background limit*'
        }

        It 'throws on an unknown environment or shell when resolving' {
            { (New-TimeoutsConfig ([ordered]@{})).SecondsFor('laptop', 'Bash', $false) } | Should -Throw "*unknown environment 'laptop'*"
            { (New-TimeoutsConfig ([ordered]@{})).SecondsFor('Devbox', 'widget', $false) } | Should -Throw "*unknown shell 'widget'*"
        }

        It 'resolves an executable entry, ignoring directory, extension and case' {
            $config = New-TimeoutsConfig ([ordered]@{ executables = @{ widget = 90 } })
            $config.SecondsForExecutable('Devbox', 'widget') | Should -Be 90
            $config.SecondsForExecutable('Devbox', 'C:\tools\Widget.exe') | Should -Be 90
            $config.SecondsForExecutable('Pipeline', '/usr/bin/widget') | Should -Be 90
        }

        It "falls back to the environment's pwsh limit for an unlisted or blank executable" {
            $config = New-TimeoutsConfig ([ordered]@{ limits = @{ devbox = @{ pwsh = 7 } }; executables = @{ widget = 90 } })
            $config.SecondsForExecutable('Devbox', 'gadget') | Should -Be 7
            $config.SecondsForExecutable('Devbox', '') | Should -Be 7
            $config.SecondsForExecutable('Devbox', $null) | Should -Be 7
            $config.SecondsForExecutable('Pipeline', 'gadget') | Should -Be 600
        }

        It 'throws on an unknown key at <path>' -ForEach @(
            @{ path = 'the top level'; data = @{ nope = 1 }; expected = "*unknown key 'nope'*" }
            @{ path = 'limits'; data = @{ limits = @{ laptop = @{} } }; expected = "*unknown key 'limits.laptop'*" }
            @{ path = 'an environment'; data = @{ limits = @{ devbox = @{ widget = 1 } } }; expected = "*unknown key 'limits.devbox.widget'*" }
            @{ path = 'bash'; data = @{ limits = @{ devbox = @{ bash = @{ idle = 1 } } } }; expected = "*unknown key 'limits.devbox.bash.idle'*" }
        ) {
            { New-TimeoutsConfig $data } | Should -Throw $expected
        }

        It 'throws on the removed default_seconds key' {
            { New-TimeoutsConfig ([ordered]@{ default_seconds = 10 }) } | Should -Throw "*unknown key 'default_seconds'*"
        }

        It 'throws on a non-positive or non-whole limit, including a quoted number (there is no "no limit" value)' -ForEach @(0, -1, 2.5, 'ten', '10') {
            { New-TimeoutsConfig ([ordered]@{ limits = @{ devbox = @{ pwsh = $_ } } }) } | Should -Throw '*invalid limits.devbox.pwsh*'
        }

        It 'throws on a background limit below its foreground limit' {
            { New-TimeoutsConfig ([ordered]@{ limits = @{ pipeline = @{ bash = @{ foreground = 60; background = 30 } } } }) } |
                Should -Throw '*limits.pipeline.bash: background (30) is below foreground (60)*'
        }

        It 'throws on a shape that is not a map at <path>' -ForEach @(
            @{ path = 'limits'; data = @{ limits = 5 }; expected = '*invalid limits (must be a map*' }
            @{ path = 'an environment'; data = @{ limits = @{ devbox = 5 } }; expected = '*invalid limits.devbox (must be a map*' }
            @{ path = 'bash'; data = @{ limits = @{ devbox = @{ bash = 5 } } }; expected = '*invalid limits.devbox.bash (must be a map*' }
        ) {
            { New-TimeoutsConfig $data } | Should -Throw $expected
        }

        It 'resolves the test-run defaults: tier limits L0 < L1 < L2 < L3 < L4, and a three-minute run budget' {
            $config = New-TimeoutsConfig ([ordered]@{})
            $levels = $config.TestLevelLimitsMs()
            $levels['L0'] | Should -Be 400
            $levels['L1'] | Should -Be 2000
            $levels['L2'] | Should -Be 30000
            $levels['L3'] | Should -Be 120000
            $levels['L4'] | Should -Be 600000
            @($levels.Keys | Sort-Object) | Should -Be ([Catzc.Base.Timeouts.TestTiers]::Names)
            $config.TestRunSeconds() | Should -Be 180
            $config.tests.run_seconds | Should -Be 180
            $config.EngineStartSeconds() | Should -Be 150
            $config.tests.engine_start_seconds | Should -Be 150
            $config.RunListSeconds() | Should -Be 300
            $config.tests.run_list_seconds | Should -Be 300
            $config.RunLockSeconds() | Should -Be 120
            $config.tests.run_lock_seconds | Should -Be 120
        }

        It 'overrides the run-lock wait alone' -Tag 'ADR-AUTO-FAILFAST-BOUNDEVERYWAIT' {
            $config = New-TimeoutsConfig ([ordered]@{ tests = @{ run_lock_seconds = 30 } })
            $config.RunLockSeconds() | Should -Be 30
            $config.RunListSeconds() | Should -Be 300
        }

        It 'overrides the run-list bound alone' -Tag 'ADR-AUTO-FAILFAST-BOUNDEVERYWAIT' {
            $config = New-TimeoutsConfig ([ordered]@{ tests = @{ run_list_seconds = 120 } })
            $config.RunListSeconds() | Should -Be 120
            $config.EngineStartSeconds() | Should -Be 150
        }

        It 'overrides one test tier and the run budget, keeping the other defaults' {
            $config = New-TimeoutsConfig ([ordered]@{ tests = @{ level_ms = @{ L3 = 150000 }; run_seconds = 240 } })
            $config.TestLevelLimitsMs()['L3'] | Should -Be 150000
            $config.TestLevelLimitsMs()['L2'] | Should -Be 30000
            $config.TestRunSeconds() | Should -Be 240
            $config.EngineStartSeconds() | Should -Be 150
        }

        It 'overrides the engine start bound alone' -Tag 'ADR-AUTO-FAILFAST-BOUNDEVERYWAIT' {
            $config = New-TimeoutsConfig ([ordered]@{ tests = @{ engine_start_seconds = 90 } })
            $config.EngineStartSeconds() | Should -Be 90
            $config.TestRunSeconds() | Should -Be 180
        }

        It 'throws on a bad tests section: <case>' -ForEach @(
            @{ case = 'not a map'; data = @{ tests = 5 }; expected = '*invalid tests (must be a map*' }
            @{ case = 'an unknown key'; data = @{ tests = @{ budget = 1 } }; expected = "*unknown key 'tests.budget'*" }
            @{ case = 'an unknown tier'; data = @{ tests = @{ level_ms = @{ L5 = 1 } } }; expected = "*unknown key 'tests.level_ms.L5'*" }
            @{ case = 'a zero tier limit'; data = @{ tests = @{ level_ms = @{ L0 = 0 } } }; expected = "*invalid tests.level_ms.L0 '0'*" }
            @{ case = 'a quoted run budget'; data = @{ tests = @{ run_seconds = '180' } }; expected = "*invalid tests.run_seconds '180'*" }
            @{ case = 'a zero engine start bound'; data = @{ tests = @{ engine_start_seconds = 0 } }; expected = "*invalid tests.engine_start_seconds '0'*" }
            @{ case = 'a zero run-list bound'; data = @{ tests = @{ run_list_seconds = 0 } }; expected = "*invalid tests.run_list_seconds '0'*" }
            @{ case = 'a zero run-lock wait'; data = @{ tests = @{ run_lock_seconds = 0 } }; expected = "*invalid tests.run_lock_seconds '0'*" }
        ) {
            { New-TimeoutsConfig $data } | Should -Throw $expected
        }

        It 'throws on an executable key with a directory or extension' {
            { New-TimeoutsConfig ([ordered]@{ executables = @{ 'widget.exe' = 9 } }) } |
                Should -Throw "*invalid executables key 'widget.exe'*"
        }

        It 'reports every violation in one throw' {
            $err = { New-TimeoutsConfig ([ordered]@{ nope = 1; limits = @{ devbox = @{ pwsh = 0 } }; executables = @{ widget = 0 } }) } |
                Should -Throw -PassThru
            $err.Exception.Message | Should -BeLike "*unknown key 'nope'*"
            $err.Exception.Message | Should -BeLike "*invalid limits.devbox.pwsh '0'*"
            $err.Exception.Message | Should -BeLike "*invalid executables.widget '0'*"
        }

        It 'resolves the Watch-Blocking defaults, one second and one millisecond, when wait is absent' -Tag 'ADR-AUTO-DEFAULT-ONERESOLUTIONORDER' {
            $config = New-TimeoutsConfig ([ordered]@{})
            $config.wait['seconds'] | Should -Be 1
            $config.wait['milliseconds'] | Should -Be 1
            [Catzc.Base.Timeouts.TimeoutsConfig]::WaitDefaultSeconds | Should -Be 1
            [Catzc.Base.Timeouts.TimeoutsConfig]::WaitDefaultMilliseconds | Should -Be 1
        }

        It 'overrides one wait number and keeps the other default' {
            $config = New-TimeoutsConfig ([ordered]@{ wait = @{ milliseconds = 250 } })
            $config.wait['seconds'] | Should -Be 1
            $config.wait['milliseconds'] | Should -Be 250
        }

        It 'rejects a bad wait section: <case>' -ForEach @(
            @{ case = 'an unknown key'; wait = @{ hours = 1 }; message = "*unknown key 'wait.hours'*" }
            @{ case = 'a zero'; wait = @{ seconds = 0 }; message = "*invalid wait.seconds '0'*" }
            @{ case = 'a negative number'; wait = @{ milliseconds = -5 }; message = "*invalid wait.milliseconds '-5'*" }
            @{ case = 'a shape that is not a map'; wait = 3; message = '*invalid wait (must be a map*' }
        ) {
            { New-TimeoutsConfig ([ordered]@{ wait = $wait }) } | Should -Throw $message
        }

        It 'reads per-command limits, case-insensitively, and answers null for a command without one' -Tag 'ADR-PWSH-ASSERT-DECLAREDTIMELIMIT' {
            $config = New-TimeoutsConfig ([ordered]@{ commands = @{ 'Sync-Widget' = 45 } })
            $config.SecondsForCommand('sync-widget') | Should -Be 45
            $config.SecondsForCommand('Sync-Gadget') | Should -BeNullOrEmpty
            (New-TimeoutsConfig ([ordered]@{})).commands.Count | Should -Be 0
        }

        It 'rejects a commands key that is not a function name, and a limit that is not a positive whole number' {
            $err = { New-TimeoutsConfig ([ordered]@{ commands = @{ widget = 45; 'Sync-Gadget' = 0 } }) } | Should -Throw -PassThru
            $err.Exception.Message | Should -BeLike "*invalid commands key 'widget' (a function name: Verb-Noun)*"
            $err.Exception.Message | Should -BeLike "*invalid commands.Sync-Gadget '0'*"
        }
    }
}
