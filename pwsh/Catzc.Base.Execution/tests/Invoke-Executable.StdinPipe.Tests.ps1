BeforeAll {
    function script:Start-InputPipeChild {
        # sort reads stdin to EOF.
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
        [pscustomobject]@{ Process = $child; Output = $child.StandardOutput.ReadToEndAsync(); Errors = $child.StandardError.ReadToEndAsync() }
    }
    # Only a run that blocks every launch ('1') keeps the child from starting; 'tier' arms the L0 and L1 Describes alone.
    $script:inputPipeChild = if ($env:CATZC_BLOCK_REAL_PROCESS -ne '1') {
        Start-InputPipeChild
    }
}

AfterAll {
    # A filter that skipped the L2 test leaves its child running.
    if ($script:inputPipeChild) {
        if (-not $script:inputPipeChild.Process.HasExited) {
            $script:inputPipeChild.Process.Kill($true)
        }
        $script:inputPipeChild.Process.StandardInput.Close()
        $script:inputPipeChild.Process.Dispose()
    }
}

# L2: a real child pwsh whose stdin is a pipe that stays open — the shape of a worker or an agent's shell.
Describe 'Invoke-Executable from a caller whose stdin is not a terminal' -Tag 'L2', 'logic' {
    It 'gives a visible run an empty, closed stdin too, so a stdin reader finishes instead of waiting on the pipe' {
        # The child started in the file's BeforeAll; a run that started none starts it now.
        $started = if ($script:inputPipeChild) {
            $script:inputPipeChild
        }
        else {
            Start-InputPipeChild
        }
        $script:inputPipeChild = $null
        $child = $started.Process
        $outputTask = $started.Output
        $errorTask = $started.Errors
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
