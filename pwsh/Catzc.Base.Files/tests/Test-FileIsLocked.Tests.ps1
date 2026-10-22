Describe 'Test-FileIsLocked / Test-FileIsNotLocked' -Tag 'L0', 'logic' {
    BeforeEach {
        $script:f = Join-Path $TestDrive ([guid]::NewGuid().ToString('N') + '.bin')
        Set-Content -Path $f -Value 'data'
    }

    It 'reports an openable file as not locked' {
        Test-FileIsLocked $f | Should -BeFalse
        Test-FileIsNotLocked $f | Should -BeTrue
    }

    It 'reports a held-open file as locked (Windows)' {
        if (-not $IsWindows) {
            Set-ItResult -Skipped -Because 'unix_not_advisory_lock'; return
        }

        $stream = [System.IO.File]::Open($f, 'Open', 'Read', 'None')
        try {
            Test-FileIsLocked $f | Should -BeTrue
            Test-FileIsNotLocked $f | Should -BeFalse
        }
        finally {
            $stream.Dispose()
        }
    }

    It 'throws on a missing path' {
        { Test-FileIsLocked (Join-Path $TestDrive 'does-not-exist.bin') } | Should -Throw
    }
}
