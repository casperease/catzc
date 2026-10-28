Describe 'Invoke-CatzcCommand' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:entry = Join-Path $PSScriptRoot '../assets/Invoke-CatzcCommand.ps1'
        $script:importer = Join-Path $TestDrive 'widget-importer.ps1'
        [System.IO.File]::WriteAllText($script:importer,
            "function Get-Widget { 'widget' }`nfunction Test-Gadget { param([string] `$Result) [pscustomobject]@{ Result = `$Result } }`nfunction Test-Doohickey { param([string[]] `$Issue = @(), [switch] `$PassThru) if (`$PassThru) { [pscustomobject]@{ Subject = 'doohickey'; IssueCount = @(`$Issue).Count; Issues = `$Issue; ReportPath = 'out/doohickey' } } }`nfunction Test-Gizmo { param([string[]] `$Outcome) foreach (`$each in `$Outcome) { [pscustomobject]@{ Name = 'gizmo'; Outcome = `$each } } }`nfunction Invoke-TestFile { [CmdletBinding()] param([string] `$Path, [switch] `$PassThru) if (`$PassThru) { [pscustomobject]@{ Result = 'Failed' } } }`nfunction Write-Message { param([AllowEmptyString()] [string] `$Message, [switch] `$NoHeader) Write-Information `$Message -InformationAction Continue }`n")
        # An importer that throws, so a run that must not import shows it did not.
        $script:throwingImporter = Join-Path $TestDrive 'throwing-importer.ps1'
        [System.IO.File]::WriteAllText($script:throwingImporter, "throw 'imported'`n")
        # Each run takes a lock of its own, so a real run holding the machine's lock never touches the test.
        $script:lockName = "Local\catzc-test-$([guid]::NewGuid())"
        # The variable a lock holder passes to the processes it starts, set and cleared by the cases that need it.
        . (Join-Path $PSScriptRoot '../assets/Wait-CatzcRunLock.ps1')
        $script:inherit = Get-CatzcRunLockInheritName -LockName $script:lockName
        # Holds the lock on another thread for the given milliseconds, the way another run would.
        function script:Start-LockHolder {
            param([string] $Name, [int] $Milliseconds)
            $taken = [System.Threading.ManualResetEventSlim]::new($false)
            $shell = [powershell]::Create().AddScript({
                    param($Name, $Milliseconds, $Taken)
                    $held = [System.Threading.Mutex]::new($false, $Name)
                    $null = $held.WaitOne()
                    $Taken.Set()
                    Start-Sleep -Milliseconds $Milliseconds
                    $held.ReleaseMutex()
                    $held.Dispose()
                }).AddArgument($Name).AddArgument($Milliseconds).AddArgument($taken)
            $handle = $shell.BeginInvoke()
            [pscustomobject]@{ Shell = $shell; Handle = $handle; Taken = $taken.Wait(2000) }
        }
    }

    It 'reports a passing and a failing command and runs the one after the failure' {
        $lines = @(& $script:entry 'Get-Widget' 'throw "the gadget broke"' 'Get-Widget' -Importer $script:importer -LockName $script:lockName)
        $LASTEXITCODE | Should -Be 1
        $lines | Should -Be @(
            '[Invoke-CatzcCommand] passed: Get-Widget'
            '[Invoke-CatzcCommand] failed: throw "the gadget broke" — the gadget broke'
            '[Invoke-CatzcCommand] passed: Get-Widget'
            '[Invoke-CatzcCommand] 2 of 3 passed'
        )
    }

    It 'shows a command''s own output on the information stream, apart from the verdict lines' {
        $all = @(& $script:entry 'Get-Widget' -Importer $script:importer -LockName $script:lockName 6>&1 | ForEach-Object { "$_" })
        $all | Should -Be @('widget', '[Invoke-CatzcCommand] passed: Get-Widget', '[Invoke-CatzcCommand] 1 of 1 passed')
    }

    It 'counts a written error as a failure' {
        $lines = @(& $script:entry 'Write-Error "gadget error"' -Importer $script:importer -LockName $script:lockName)
        $LASTEXITCODE | Should -Be 1
        $lines[0] | Should -BeExactly '[Invoke-CatzcCommand] failed: Write-Error "gadget error" — gadget error'
    }

    It 'reads the verdict of a result object: Failed fails, Passed passes' {
        $lines = @(& $script:entry 'Test-Gadget -Result Failed' 'Test-Gadget -Result Passed' -Importer $script:importer -LockName $script:lockName)
        $LASTEXITCODE | Should -Be 1
        $lines[0] | Should -BeExactly '[Invoke-CatzcCommand] failed: Test-Gadget -Result Failed — it reported Failed'
        $lines[1] | Should -BeExactly '[Invoke-CatzcCommand] passed: Test-Gadget -Result Passed'
    }

    It 'runs a bare test-file path through Invoke-TestFile, so its red result fails the command' {
        $lines = @(& $script:entry 'widgets/Gadget.Tests.ps1' -Importer $script:importer -LockName $script:lockName)
        $LASTEXITCODE | Should -Be 1
        $lines[0] | Should -BeExactly '[Invoke-CatzcCommand] failed: widgets/Gadget.Tests.ps1 — it reported Failed'
    }

    It 'reads the outcome of per-test records, as a red pytest run returns them: one fail fails the command, pass and skip pass' {
        $lines = @(& $script:entry 'Test-Gizmo -Outcome pass, fail, fail, skip' 'Test-Gizmo -Outcome pass, skip' -Importer $script:importer -LockName $script:lockName)
        $LASTEXITCODE | Should -Be 1
        $lines | Should -Be @(
            '[Invoke-CatzcCommand] failed: Test-Gizmo -Outcome pass, fail, fail, skip — it reported 2 failed test(s)'
            '[Invoke-CatzcCommand] passed: Test-Gizmo -Outcome pass, skip'
            '[Invoke-CatzcCommand] 1 of 2 passed'
        )
    }

    It 'judges a gate called with -PassThru by its issue count: one issue fails the command, none passes' {
        $lines = @(& $script:entry 'Test-Doohickey -Issue "widget.ps1: a loose gadget" -PassThru' 'Test-Doohickey -PassThru' -Importer $script:importer -LockName $script:lockName)
        $LASTEXITCODE | Should -Be 1
        $lines | Should -Be @(
            '[Invoke-CatzcCommand] failed: Test-Doohickey -Issue "widget.ps1: a loose gadget" -PassThru — it reported 1 doohickey issue(s)'
            '[Invoke-CatzcCommand] passed: Test-Doohickey -PassThru'
            '[Invoke-CatzcCommand] 1 of 2 passed'
        )
    }

    It 'counts a red test file as failed when the line names no -PassThru' {
        $lines = @(& $script:entry 'Invoke-TestFile widget.Tests.ps1' -Importer $script:importer -LockName $script:lockName)
        $LASTEXITCODE | Should -Be 1
        $lines | Should -Be @(
            '[Invoke-CatzcCommand] failed: Invoke-TestFile widget.Tests.ps1 — it reported Failed'
            '[Invoke-CatzcCommand] 0 of 1 passed'
        )
    }

    It 'exits 0 when every command passes' {
        $lines = @(& $script:entry 'Get-Widget' -Importer $script:importer -LockName $script:lockName)
        $LASTEXITCODE | Should -Be 0
        $lines[-1] | Should -BeExactly '[Invoke-CatzcCommand] 1 of 1 passed'
    }

    It 'runs every command from the importer''s folder, and gives the caller its location back' {
        $caller = (Get-Location).Path
        $lines = @(& $script:entry "if ((Get-Location).Path -ne '$TestDrive') { throw `"ran in `$((Get-Location).Path)`" }" -Importer $script:importer -LockName $script:lockName)
        $lines[0] | Should -BeLike '`[Invoke-CatzcCommand`] passed: *'
        (Get-Location).Path | Should -Be $caller
    }

    It 'releases the run lock when the import throws' {
        { & $script:entry 'Get-Widget' -Importer $script:throwingImporter -LockName $script:lockName } |
            Should -Throw 'imported'
        # Another thread takes it at once, which it could not while this thread still held it.
        $holder = Start-LockHolder -Name $script:lockName -Milliseconds 1
        try {
            $holder.Taken | Should -BeTrue
        }
        finally {
            $holder.Shell.EndInvoke($holder.Handle)
            $holder.Shell.Dispose()
        }
    }

    It 'throws on -InBurst when no burst holds the lock' {
        { & $script:entry 'Get-Widget' -Importer $script:importer -LockName $script:lockName -InBurst } |
            Should -Throw '*no burst holds*'
    }

    It 'takes no lock with -InBurst while a burst holds it' {
        $burst = [System.Threading.EventWaitHandle]::new($false, [System.Threading.EventResetMode]::ManualReset,
            "$script:lockName-burst")
        $holder = Start-LockHolder -Name $script:lockName -Milliseconds 1500
        try {
            $lines = @(& $script:entry 'Get-Widget' -Importer $script:importer -LockName $script:lockName -InBurst)
            $lines | Should -Be @('[Invoke-CatzcCommand] passed: Get-Widget', '[Invoke-CatzcCommand] 1 of 1 passed')
        }
        finally {
            $holder.Shell.EndInvoke($holder.Handle)
            $holder.Shell.Dispose()
            $burst.Dispose()
        }
    }

    It 'throws when no command is named' {
        { & $script:entry -Importer $script:importer -LockName $script:lockName } |
            Should -Throw '*name at least one command*'
    }

    It 'says it waits for a held run lock, then runs once the lock is free' -Tag 'ADR-AUTO-FAILFAST-BOUNDEVERYWAIT' {
        $holder = Start-LockHolder -Name $script:lockName -Milliseconds 300
        try {
            $lines = @(& $script:entry 'Get-Widget' -Importer $script:importer -LockName $script:lockName -LockSeconds 1)
            $LASTEXITCODE | Should -Be 0
            $lines[0] |
                Should -BeExactly '[Invoke-CatzcCommand] waiting for the run lock: another run holds it (up to 1 s)'
            $lines[1] | Should -BeExactly '[Invoke-CatzcCommand] passed: Get-Widget'
        }
        finally {
            $holder.Shell.EndInvoke($holder.Handle)
            $holder.Shell.Dispose()
        }
    }

    It 'runs at once under the hold of the live ancestor its lock variable names, leaving the hold to that ancestor' -Tag 'ADR-AUTO-FAILFAST-BOUNDEVERYWAIT' {
        $holder = Start-LockHolder -Name $script:lockName -Milliseconds 1500
        # The parent process stands in for the ancestor whose hold this process inherited.
        $parent = (Get-Process -Id $PID).Parent.Id
        [System.Environment]::SetEnvironmentVariable($script:inherit, "$parent|$(Get-CatzcRunLockProcessStart -ProcessId $parent)")
        try {
            $lines = @(& $script:entry 'Get-Widget' -Importer $script:importer -LockName $script:lockName -LockSeconds 1)
            $LASTEXITCODE | Should -Be 0
            $lines | Should -Be @('[Invoke-CatzcCommand] passed: Get-Widget', '[Invoke-CatzcCommand] 1 of 1 passed')
            [System.Environment]::GetEnvironmentVariable($script:inherit) | Should -BeLike "$parent|*"
        }
        finally {
            [System.Environment]::SetEnvironmentVariable($script:inherit, $null)
            $holder.Shell.EndInvoke($holder.Handle)
            $holder.Shell.Dispose()
        }
    }

    It 'waits as any run does when its lock variable names <case>' -Tag 'ADR-AUTO-FAILFAST-BOUNDEVERYWAIT' -ForEach @(
        # Windows process ids are multiples of four, so an odd id names no process.
        @{ case = 'a gone process'; Value = { '4194303|1' }; Other = $false }
        @{ case = 'a reused process id'; Value = { "$PID|1" }; Other = $false }
        @{ case = 'nothing it can read'; Value = { 'gadget' }; Other = $false }
        @{ case = 'this process itself'; Value = { "$PID|$(Get-CatzcRunLockProcessStart -ProcessId $PID)" }; Other = $false }
        @{ case = 'the live holder of another lock'; Value = { $parent = (Get-Process -Id $PID).Parent.Id; "$parent|$(Get-CatzcRunLockProcessStart -ProcessId $parent)" }; Other = $true }
    ) {
        $name = if ($Other) {
            Get-CatzcRunLockInheritName -LockName "$script:lockName-widget"
        }
        else {
            $script:inherit
        }
        $holder = Start-LockHolder -Name $script:lockName -Milliseconds 1500
        [System.Environment]::SetEnvironmentVariable($name, (& $Value))
        try {
            $lines = @(& $script:entry 'throw "ran"' -Importer $script:throwingImporter -LockName $script:lockName -LockSeconds 1)
            $LASTEXITCODE | Should -Be 1
            $lines | Should -Be @(
                '[Invoke-CatzcCommand] waiting for the run lock: another run holds it (up to 1 s)'
                '[Invoke-CatzcCommand] run lock busy: another run held it for 1 s, so nothing ran'
            )
        }
        finally {
            [System.Environment]::SetEnvironmentVariable($name, $null)
            $holder.Shell.EndInvoke($holder.Handle)
            $holder.Shell.Dispose()
        }
    }

    It 'stops with run lock busy, importing and running nothing, when the lock stays held past its wait' -Tag 'ADR-AUTO-FAILFAST-BOUNDEVERYWAIT' {
        $holder = Start-LockHolder -Name $script:lockName -Milliseconds 1500
        try {
            $lines = @(& $script:entry 'throw "ran"' -Importer $script:throwingImporter -LockName $script:lockName -LockSeconds 1)
            $LASTEXITCODE | Should -Be 1
            $lines | Should -Be @(
                '[Invoke-CatzcCommand] waiting for the run lock: another run holds it (up to 1 s)'
                '[Invoke-CatzcCommand] run lock busy: another run held it for 1 s, so nothing ran'
            )
        }
        finally {
            $holder.Shell.EndInvoke($holder.Handle)
            $holder.Shell.Dispose()
        }
    }
}

Describe 'Invoke-CatzcCommand — in a child pwsh process' -Tag 'L2', 'logic' {
    BeforeAll {
        $script:entry = Join-Path $PSScriptRoot '../assets/Invoke-CatzcCommand.ps1'
        $script:importer = Join-Path $TestDrive 'widget-importer.ps1'
        [System.IO.File]::WriteAllText($script:importer,
            "function Get-Widget { 'widget' }`nfunction Write-Message { param([AllowEmptyString()] [string] `$Message, [switch] `$NoHeader) Write-Information `$Message -InformationAction Continue }`n")
        . (Join-Path $PSScriptRoot '../assets/Wait-CatzcRunLock.ps1')
    }

    BeforeEach {
        # Each test takes a lock of its own, so a real run on the machine never touches it.
        $script:lockName = "Local\catzc-test-$([guid]::NewGuid())"
    }

    It 'passes its hold to a nested run it starts in a child process, which runs at once, and ends the hold with the run' -Tag 'ADR-AUTO-FAILFAST-BOUNDEVERYWAIT' {
        $nested = "`$out = @(pwsh -NoProfile -NonInteractive -File '$script:entry' 'Get-Widget' -Importer '$script:importer' -LockName '$script:lockName' -LockSeconds 1 -BudgetSeconds 5); if (`$LASTEXITCODE -ne 0) { throw (`$out -join ' / ') }"
        $lines = @(& $script:entry $nested -Importer $script:importer -LockName $script:lockName -LockSeconds 1)
        $LASTEXITCODE | Should -Be 0
        $lines[-1] | Should -BeExactly '[Invoke-CatzcCommand] 1 of 1 passed'
        [System.Environment]::GetEnvironmentVariable((Get-CatzcRunLockInheritName -LockName $script:lockName)) | Should -BeNullOrEmpty
    }
}
