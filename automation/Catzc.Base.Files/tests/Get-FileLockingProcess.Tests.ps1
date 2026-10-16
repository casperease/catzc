<#
---
catzc:
  immutable:
    path: automation/Catzc.Base.Files/tests/Get-FileLockingProcess.Tests.ps1
    folder: tests
    name: get-file-locking-process-tests
    filetype: ps1
    kind: test
    language: powershell
    track: automation
    module: Catzc.Base.Files
    moduletype: pwsh-folder
    catzc_bundle: azure
---
#>

Describe 'Get-FileLockingProcess' -Tag 'L0', 'logic' {
    BeforeEach {
        $script:f = Join-Path $TestDrive ([guid]::NewGuid().ToString('N') + '.bin')
        Set-Content -Path $f -Value 'data'
    }

    It 'returns nothing for a file no process holds' {
        @(Get-FileLockingProcess $f).Count | Should -Be 0
    }

    It 'names this session as the holder of a file it has open (Windows)' {
        if (-not $IsWindows) {
            Set-ItResult -Skipped -Because 'unix_not_advisory_lock'; return
        }

        $stream = [System.IO.File]::Open($f, 'Open', 'Read', 'None')
        try {
            $holders = @(Get-FileLockingProcess $f)
        }
        finally {
            $stream.Dispose()
        }
        $self = $holders | Where-Object { $_.ProcessId -eq $PID }
        $self | Should -Not -BeNullOrEmpty
        $self.Name | Should -Be ([System.IO.Path]::GetFileName((Get-Process -Id $PID).Path))
        $self.Started | Should -BeGreaterThan ([datetime]::MinValue)
        "$self" | Should -BeLike "*(PID $PID, started *"
    }

    It 'returns nothing off Windows, where locks are advisory' {
        if ($IsWindows) {
            Set-ItResult -Skipped -Because 'windows_mandatory_lock'; return
        }

        $stream = [System.IO.File]::Open($f, 'Open', 'Read', 'None')
        try {
            @(Get-FileLockingProcess $f).Count | Should -Be 0
        }
        finally {
            $stream.Dispose()
        }
    }

    It 'throws on a missing path' {
        { Get-FileLockingProcess (Join-Path $TestDrive 'does-not-exist.bin') } | Should -Throw
    }
}
