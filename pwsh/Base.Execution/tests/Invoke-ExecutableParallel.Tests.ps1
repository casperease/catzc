Describe 'Invoke-ExecutableParallel' -Tag 'L0', 'logic' {
    It 'returns nothing for an empty command list, and starts nothing' {
        @(Invoke-ExecutableParallel -Command @()) | Should -HaveCount 0
    }

    It 'with -DryRun returns the commands it would run, in order, and starts nothing' {
        Invoke-ExecutableParallel -Command 'widget --one', 'gadget --two' -DryRun | Should -Be @('widget --one', 'gadget --two')
    }

    It 'throws on a real launch during a unit test, naming the first command, so a missed mock never runs the tool' {
        Mock Test-RealProcessBlocked { $true } -ModuleName Catzc.Base.Execution
        { Invoke-ExecutableParallel -Command 'widget --one', 'gadget --two' } |
            Should -Throw "*Blocked 2 real process launch(es)*'widget --one'*"
    }
}

Describe 'Invoke-ExecutableParallel — the shipped throttle' -Tag 'L1', 'integrity' {
    It 'reads its default throttle from the timeouts config, four processes unless the file says otherwise' {
        (Get-Config -Config timeouts).parallel['processes'] | Should -Be ([Catzc.Base.Timeouts.TimeoutsConfig]::ParallelDefaultProcesses)
    }
}

Describe 'Invoke-ExecutableParallel — real processes' -Tag 'L2', 'logic' {
    # where.exe or which and a shell's exit, real executables on every platform: echo is a shell builtin on Windows.
    BeforeAll {
        $script:okCmd = if ($IsWindows) {
            'where.exe where'
        }
        else {
            'which which'
        }
        $script:failCmd = if ($IsWindows) {
            'cmd /c exit 3'
        }
        else {
            'bash -c "exit 3"'
        }
        $script:pwsh = (Get-Process -Id $PID).Path
    }

    It 'returns one result per command, in the commands'' order, whatever order they finish in' {
        $results = @(Invoke-ExecutableParallel -Command $okCmd, $failCmd, $okCmd -NoAssert -Silent)
        $results | Should -HaveCount 3
        @($results | ForEach-Object ExitCode) | Should -Be @(0, 3, 0)
    }

    It 'throws naming every failed command unless -NoAssert' {
        { Invoke-ExecutableParallel -Command $okCmd, $failCmd -Silent } | Should -Throw '*1 of 2 command(s) failed*exit 3*'
    }

    It 'runs the commands side by side, at most the throttle at a time' {
        $sleep = "`"$pwsh`" -NoProfile -NonInteractive -Command `"Start-Sleep -Seconds 1`""
        $timer = [System.Diagnostics.Stopwatch]::StartNew()
        $null = Invoke-ExecutableParallel -Command $sleep, $sleep, $sleep, $sleep -ThrottleLimit 4 -Silent
        # Each start plus its second is about two seconds, so one after another takes eight; side by side well under six.
        $timer.Elapsed.TotalSeconds | Should -BeLessThan 6
    }
}
