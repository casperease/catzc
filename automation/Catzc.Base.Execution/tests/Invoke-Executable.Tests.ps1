<#
---
catzc:
  immutable:
    path: automation/Catzc.Base.Execution/tests/Invoke-Executable.Tests.ps1
    folder: tests
    name: invoke-executable-tests
    filetype: ps1
    kind: test
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.Execution
    moduletype: pwsh-folder
    catzc_bundle: azure
  edges:
    page: docs/references/automation/catzc-base-execution/tests/Invoke-Executable.Tests.ps1.md
    cites:
      - ADR-AUTO-TEST#{10,38}
---
#>

Describe 'Invoke-Executable' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:simpleCmd = if ($IsWindows) {
            'where.exe where'
        }
        else {
            'which which'
        }
        $script:failCmd = if ($IsWindows) {
            'cmd /c exit 1'
        }
        else {
            'bash -c "exit 1"'
        }
        $script:fail42Cmd = if ($IsWindows) {
            'cmd /c exit 42'
        }
        else {
            'bash -c "exit 42"'
        }
        $script:multiLineCmd = if ($IsWindows) {
            'cmd /c "echo line1 & echo line2"'
        }
        else {
            'bash -c "echo line1; echo line2"'
        }
        $script:stderrCmd = if ($IsWindows) {
            'cmd /c "echo errtext 1>&2"'
        }
        else {
            'bash -c "echo errtext >&2"'
        }
        $script:bothCmd = if ($IsWindows) {
            'cmd /c "echo out & echo err 1>&2"'
        }
        else {
            'bash -c "echo out; echo err >&2"'
        }
        $script:cwdCmd = if ($IsWindows) {
            'cmd /c cd'
        }
        else {
            'bash -c pwd'
        }
        $script:silentSuccessCmd = if ($IsWindows) {
            'cmd /c exit 0'
        }
        else {
            'bash -c "exit 0"'
        }
    }

    Context 'asset dependencies' {
        It 'CliRunner.cs exists' {
            Join-Path $PSScriptRoot '../types/CliRunner.cs' | Should -Exist
        }
    }

    Context 'DryRun' {
        It 'returns command string in default (Stream) mode' {
            $result = Invoke-Executable 'anything here' -DryRun
            $result | Should -Be 'anything here'
            $result | Should -BeOfType [string]
        }

        It 'returns command string with -Direct' {
            $result = Invoke-Executable 'anything here' -Direct -DryRun
            $result | Should -Be 'anything here'
        }

        It 'does not execute the command' {
            { Invoke-Executable $failCmd -DryRun } | Should -Not -Throw
        }
    }

    Context 'unit-test tripwire (CATZC_BLOCK_REAL_PROCESS)' {
        AfterEach { Remove-Item Env:\CATZC_BLOCK_REAL_PROCESS -ErrorAction Ignore }

        It 'throws instead of launching a real process when the flag is set' -Tag 'ADR-AUTO-TEST#10', 'ADR-AUTO-TEST#38' {
            $env:CATZC_BLOCK_REAL_PROCESS = '1'
            { Invoke-Executable $simpleCmd -Silent } | Should -Throw '*Blocked a real process*'
        }

        It 'exempts -DryRun (it never launches a process)' {
            $env:CATZC_BLOCK_REAL_PROCESS = '1'
            Invoke-Executable 'anything here' -DryRun | Should -Be 'anything here'
        }

        It 'is inert when the flag is not set' {
            { Invoke-Executable $simpleCmd -Silent } | Should -Not -Throw
        }
    }

    Context 'Stream mode (default) — execution' {
        It 'runs a command successfully' {
            { Invoke-Executable $simpleCmd -Silent } | Should -Not -Throw
        }

        It 'returns $null without -PassThru' {
            $result = Invoke-Executable $simpleCmd -Silent
            $result | Should -BeNullOrEmpty
        }

        It 'throws on non-zero exit code' {
            { Invoke-Executable $failCmd -Silent } | Should -Throw
        }

        It 'does not throw with -NoAssert' {
            { Invoke-Executable $failCmd -NoAssert -Silent } | Should -Not -Throw
        }
    }

    Context 'Stream mode — PassThru result object' {
        It 'returns Catzc.Base.Execution.CliResult type' {
            $result = Invoke-Executable $simpleCmd -PassThru -Silent
            $result | Should -Not -BeNullOrEmpty
            $result | Should -BeOfType ([Catzc.Base.Execution.CliResult])
        }

        It '.Output contains stdout' {
            $result = Invoke-Executable $simpleCmd -PassThru -Silent
            $result.Output | Should -Not -BeNullOrEmpty
        }

        It '.Output is a string not an array for multi-line' {
            $result = Invoke-Executable $multiLineCmd -PassThru -Silent
            $result.Output | Should -BeOfType [string]
            $result.Output | Should -Match 'line1'
            $result.Output | Should -Match 'line2'
        }

        It '.Errors contains stderr' {
            $result = Invoke-Executable $stderrCmd -PassThru -NoAssert -Silent
            $result.Errors | Should -Match 'errtext'
        }

        It '.Full contains both stdout and stderr' {
            $result = Invoke-Executable $bothCmd -PassThru -NoAssert -Silent
            $result.Full | Should -Match 'out'
            $result.Full | Should -Match 'err'
        }

        It '.ExitCode is 0 on success' {
            $result = Invoke-Executable $simpleCmd -PassThru -Silent
            $result.ExitCode | Should -Be 0
        }

        It '.ExitCode captures non-zero with -NoAssert' {
            $result = Invoke-Executable $fail42Cmd -PassThru -NoAssert -Silent
            $result.ExitCode | Should -Be 42
        }

        It '.Raw is an array of output lines' {
            $result = Invoke-Executable $multiLineCmd -PassThru -Silent
            $result.Raw.Count | Should -BeGreaterOrEqual 2
        }
    }

    Context 'Stream mode — Silent' {
        It 'returns $null with -Silent and no -PassThru' {
            $result = Invoke-Executable $simpleCmd -Silent
            $result | Should -BeNullOrEmpty
        }

        It '-PassThru -Silent still captures output' {
            $result = Invoke-Executable $simpleCmd -PassThru -Silent
            $result.Output | Should -Not -BeNullOrEmpty
        }

        It '-Silent does not affect exit code assertion' {
            { Invoke-Executable $failCmd -Silent } | Should -Throw
        }

        It '-Silent gives the child an empty, closed stdin, so a stdin reader finishes at once' {
            # sort reads stdin to EOF; an inherited stdin would leave it waiting on the caller's input.
            $inputReader = if ($IsWindows) {
                "$env:SystemRoot\System32\sort.exe"
            }
            else {
                'cat'
            }
            $result = Invoke-Executable $inputReader -PassThru -Silent
            $result.ExitCode | Should -Be 0
            $result.Output | Should -BeNullOrEmpty
        }
    }

    Context 'Stream mode — InputText' {
        BeforeAll {
            # sort and cat read stdin to EOF and write it back, so what comes out is what went in.
            $script:inputReader = if ($IsWindows) {
                "$env:SystemRoot\System32\sort.exe"
            }
            else {
                'cat'
            }
        }

        It 'writes the text to the child''s stdin and closes it, so a reader finishes' {
            $result = Invoke-Executable $script:inputReader -InputText "pear`nbanana`napple`n" -PassThru -Silent
            $result.ExitCode | Should -Be 0
            @($result.Output -split "`r?`n" | Where-Object { $_ } | Sort-Object) | Should -Be @('apple', 'banana', 'pear')
        }

        It 'delivers an input larger than the pipe buffer without a deadlock' {
            $lines = 1..20000 | ForEach-Object { "widget-$_" }
            $result = Invoke-Executable $script:inputReader -InputText (($lines -join "`n") + "`n") -PassThru -Silent -TimeoutSeconds 60
            $result.ExitCode | Should -Be 0
            @($result.Output -split "`r?`n" | Where-Object { $_ }).Count | Should -Be 20000
        }

        It 'closes stdin for an empty text too, so the reader still finishes' {
            $result = Invoke-Executable $script:inputReader -InputText '' -PassThru -Silent
            $result.ExitCode | Should -Be 0
            $result.Output | Should -BeNullOrEmpty
        }

        It '-InputText and -Direct are mutually exclusive' {
            { Invoke-Executable $script:inputReader -InputText 'widget' -Direct } | Should -Throw
        }
    }

    Context 'Stream mode — AsBytes' {
        It 'captures stdout as the exact bytes written, never decoded' -Tag 'L2' {
            # L2: a real child pwsh writes bytes that are not valid UTF-8 (255, 200) next to a CR and LF.
            $writer = 'pwsh -NoProfile -Command "[Console]::OpenStandardOutput().Write([byte[]](0, 255, 200, 13, 10, 65), 0, 6)"'
            $result = Invoke-Executable $writer -AsBytes -Silent
            $result | Should -BeOfType [Catzc.Base.Execution.CliResult]
            $result.Bytes | Should -Be @(0, 255, 200, 13, 10, 65)
            $result.Output | Should -BeNullOrEmpty
        }

        It 'leaves .Bytes null on a text run' {
            (Invoke-Executable $simpleCmd -PassThru -Silent).Bytes | Should -BeNullOrEmpty
        }

        It 'still asserts the exit code, and keeps it with -NoAssert' {
            { Invoke-Executable $failCmd -AsBytes -Silent } | Should -Throw
            (Invoke-Executable $fail42Cmd -AsBytes -NoAssert -Silent).ExitCode | Should -Be 42
        }

        It '-AsBytes and -Direct are mutually exclusive' {
            { Invoke-Executable 'echo hello' -AsBytes -Direct } | Should -Throw '*Parameter set cannot be resolved*'
        }
    }

    Context 'Stream mode — no pipeline leak' {
        It 'output does not leak into caller function return' {
            function Test-StreamLeak {
                Invoke-Executable $simpleCmd -Silent
            }
            $leaked = Test-StreamLeak
            $leaked | Should -BeNullOrEmpty
        }

        It 'multi-line output does not leak' {
            function Test-MultiLineLeak {
                Invoke-Executable $multiLineCmd -Silent
            }
            $leaked = Test-MultiLineLeak
            $leaked | Should -BeNullOrEmpty
        }
    }

    Context 'Direct mode' {
        It 'output leaks to pipeline' {
            $result = Invoke-Executable 'echo hello' -Direct -Silent
            $result | Should -Be 'hello'
        }

        It 'throws on non-zero exit code' {
            { Invoke-Executable $failCmd -Direct -Silent } | Should -Throw
        }

        It 'does not throw with -NoAssert' {
            { Invoke-Executable $failCmd -Direct -NoAssert -Silent } | Should -Not -Throw
        }
    }

    Context 'parameter sets' {
        It '-PassThru and -Direct are mutually exclusive' {
            { Invoke-Executable 'echo hello' -PassThru -Direct } | Should -Throw '*Parameter set cannot be resolved*'
        }

        It '-PassThru without -Direct works' {
            $result = Invoke-Executable $simpleCmd -PassThru -Silent
            $result | Should -Not -BeNullOrEmpty
        }

        It '-Direct without -PassThru works' {
            { Invoke-Executable 'echo hello' -Direct -Silent } | Should -Not -Throw
        }

        It '-TimeoutSeconds and -Direct are mutually exclusive' {
            { Invoke-Executable 'echo hello' -TimeoutSeconds 5 -Direct } | Should -Throw '*Parameter set cannot be resolved*'
        }
    }

    Context 'time safeguard' {
        # L2: drives a real child pwsh that outlives the limit.
        It 'kills a process that outlives -TimeoutSeconds and throws a TimeoutException naming the limit' -Tag 'L2' {
            $stopwatch = [System.Diagnostics.Stopwatch]::StartNew()
            $err = { Invoke-Executable 'pwsh -NoProfile -Command Start-Sleep -Seconds 10' -TimeoutSeconds 1 -Silent } | Should -Throw -PassThru
            $stopwatch.Elapsed.TotalSeconds | Should -BeLessThan 8
            $err.Exception | Should -BeOfType [System.TimeoutException]
            $err.Exception.Message | Should -BeLike '*after 1s*timeouts.yml*'
        }

        It 'fails fast, naming the cause, when a process the command started keeps its output open after it exits' -Tag 'L2' {
            $leaver = 'pwsh -NoProfile -NonInteractive -Command "Start-Process -NoNewWindow -FilePath pwsh -ArgumentList ''-NoProfile'',''-Command'',''Start-Sleep -Seconds 20''; exit 0"'
            $stopwatch = [System.Diagnostics.Stopwatch]::StartNew()
            $err = { Invoke-Executable $leaver -TimeoutSeconds 60 -Silent -PassThru } | Should -Throw -PassThru
            $stopwatch.Elapsed.TotalSeconds | Should -BeLessThan 15
            $err.Exception | Should -BeOfType [System.IO.IOException]
            $err.Exception.Message | Should -BeLike '*still holds its output open*--disable-build-servers*'
        }

        It "defaults the limit to the executable's entry from Get-TimeoutSeconds" {
            Mock Get-TimeoutSeconds -ModuleName Catzc.Base.Execution { 30 }
            Invoke-Executable $simpleCmd -PassThru -Silent | Should -Not -BeNullOrEmpty
            Should -Invoke Get-TimeoutSeconds -ModuleName Catzc.Base.Execution -Times 1 -Exactly -ParameterFilter {
                $Executable -eq ($simpleCmd -split ' ')[0]
            }
        }
    }

    Context 'CliRunner parser — direct exec' {
        It 'handles simple command with output' {
            $result = Invoke-Executable $simpleCmd -PassThru -Silent
            $result.Output | Should -Not -BeNullOrEmpty
        }

        It 'handles multiple arguments' {
            $result = Invoke-Executable $multiLineCmd -PassThru -Silent
            $result.Output | Should -Match 'line1'
            $result.Output | Should -Match 'line2'
        }
    }

    Context 'WorkingDirectory' {
        It 'defaults to repository root in Stream mode' {
            Push-Location $env:TEMP
            try {
                $result = Invoke-Executable $cwdCmd -PassThru -Silent
                $result.Output.Trim() | Should -Be $env:RepositoryRoot
            }
            finally {
                Pop-Location
            }
        }

        It 'defaults to repository root in Direct mode' {
            Push-Location $env:TEMP
            try {
                $result = Invoke-Executable $cwdCmd -Direct -Silent
                ($result | Out-String).Trim() | Should -Be $env:RepositoryRoot
            }
            finally {
                Pop-Location
            }
        }

        It 'explicit -WorkingDirectory overrides default in Stream mode' {
            $tempDirectory = Join-Path ([System.IO.Path]::GetTempPath()) ([System.Guid]::NewGuid().ToString('N'))
            New-Item -ItemType Directory -Path $tempDirectory | Out-Null
            try {
                $result = Invoke-Executable $cwdCmd -WorkingDirectory $tempDirectory -PassThru -Silent
                ($result.Output.Trim() -replace '^/private', '') | Should -Be ($tempDirectory -replace '^/private', '')
            }
            finally {
                Remove-Item $tempDirectory -Force
            }
        }

        It 'explicit -WorkingDirectory overrides default in Direct mode' {
            $tempDirectory = Join-Path ([System.IO.Path]::GetTempPath()) ([System.Guid]::NewGuid().ToString('N'))
            New-Item -ItemType Directory -Path $tempDirectory | Out-Null
            try {
                $result = Invoke-Executable $cwdCmd -WorkingDirectory $tempDirectory -Direct -Silent
                # See the Stream-mode test: normalize the macOS /private symlink prefix on both sides.
                (($result | Out-String).Trim() -replace '^/private', '') | Should -Be ($tempDirectory -replace '^/private', '')
            }
            finally {
                Remove-Item $tempDirectory -Force
            }
        }

        It 'throws on non-existent path' {
            { Invoke-Executable $simpleCmd -WorkingDirectory (Join-Path ([System.IO.Path]::GetTempPath()) ([guid]::NewGuid().ToString('N'))) -Silent } | Should -Throw
        }
    }

    Context 'Stream mode — empty output' {
        It '.Output is empty string when command produces no stdout' {
            $result = Invoke-Executable $silentSuccessCmd -PassThru -Silent
            $result.Output | Should -BeNullOrEmpty
            $result.ExitCode | Should -Be 0
        }

        It '.Errors is empty string on successful command' {
            $result = Invoke-Executable $simpleCmd -PassThru -Silent
            $result.Errors | Should -BeNullOrEmpty
        }
    }

    Context 'CliRunner parser — quoted arguments' {
        It 'quoted argument with spaces is passed as single argument' {
            $command = if ($IsWindows) {
                'cmd /c echo "hello world"'
            }
            else {
                'bash -c "echo hello world"'
            }
            $result = Invoke-Executable $command -PassThru -Silent
            $result.Output | Should -Match 'hello world'
        }
    }

    Context 'CliRunner parser — shell operators rejected' {
        It 'unquoted pipe throws' {
            { Invoke-Executable 'where.exe foo | where.exe bar' -Silent } | Should -Throw
        }

        It 'unquoted && throws' {
            { Invoke-Executable 'where.exe foo && where.exe bar' -Silent } | Should -Throw
        }

        It 'unquoted ; throws' {
            { Invoke-Executable 'where.exe foo ; where.exe bar' -Silent } | Should -Throw
        }

        It 'unquoted & throws' {
            { Invoke-Executable 'where.exe foo & where.exe bar' -Silent } | Should -Throw
        }

        It 'pipe inside quotes does NOT throw' {
            # The parser should not reject this — the | is inside quotes.
            $command = if ($IsWindows) {
                'where.exe "foo|bar"'
            }
            else {
                'which "foo|bar"'
            }
            { Invoke-Executable $command -Silent -NoAssert } | Should -Not -Throw
        }
    }
}

# L2: a real child pwsh whose stdin is a pipe that stays open — the shape of a worker or an agent's shell.
Describe 'Invoke-Executable from a caller whose stdin is not a terminal' -Tag 'L2', 'logic' {
    It 'gives a visible run an empty, closed stdin too, so a stdin reader finishes instead of waiting on the pipe' {
        # sort reads stdin to EOF; inheriting the open pipe would leave it waiting forever.
        $inputReader = if ($IsWindows) {
            "$env:SystemRoot\System32\sort.exe"
        }
        else {
            'cat'
        }
        $importer = Join-Path (Get-RepositoryRoot) 'importer.ps1'
        $startInfo = [System.Diagnostics.ProcessStartInfo]::new('pwsh')
        $childCommand = ". '$importer' -SkipJanitors *> `$null; exit (Invoke-Executable '$inputReader' -PassThru).ExitCode"
        '-NoProfile', '-NonInteractive', '-Command', $childCommand | ForEach-Object { $startInfo.ArgumentList.Add($_) }
        $startInfo.UseShellExecute = $false
        $startInfo.RedirectStandardInput = $true   # held open and never written: the child's stdin is a live pipe
        $startInfo.RedirectStandardOutput = $true
        $startInfo.RedirectStandardError = $true
        [void]$startInfo.Environment.Remove('CATZC_BLOCK_REAL_PROCESS')
        $child = [System.Diagnostics.Process]::Start($startInfo)
        $outputTask = $child.StandardOutput.ReadToEndAsync()
        $errorTask = $child.StandardError.ReadToEndAsync()
        try {
            $exited = $child.WaitForExit(120000)
            $exited | Should -BeTrue -Because "the child should not wait on its open stdin pipe. stderr: $(if ($errorTask.IsCompleted) { $errorTask.Result })"
            $child.ExitCode | Should -Be 0 -Because "stdout: $($outputTask.Result) stderr: $($errorTask.Result)"
        }
        finally {
            if (-not $child.HasExited) {
                $child.Kill($true)
            }
            $child.StandardInput.Close()
            $child.Dispose()
        }
    }
}
