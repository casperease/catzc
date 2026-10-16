<#
---
catzc:
  immutable:
    path: automation/Catzc.Base.Files/tests/Assert-FileIsLocked.Tests.ps1
    folder: tests
    name: assert-file-is-locked-tests
    filetype: ps1
    kind: test
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.Files
    moduletype: pwsh-folder
    catzc_bundle: azure
---
#>

Describe 'Assert-FileIsLocked / Assert-FileIsNotLocked' -Tag 'L0', 'logic' {
    BeforeEach {
        $script:f = Join-Path $TestDrive ([guid]::NewGuid().ToString('N') + '.bin')
        Set-Content -Path $f -Value 'data'
    }

    It 'Assert-FileIsNotLocked passes for an openable file' {
        { Assert-FileIsNotLocked $f } | Should -Not -Throw
    }

    It 'Assert-FileIsLocked throws for an openable file' {
        { Assert-FileIsLocked $f } | Should -Throw '*locked*'
    }

    It 'honors a held-open file (Windows)' {
        if (-not $IsWindows) {
            Set-ItResult -Skipped -Because 'unix_not_advisory_lock'; return
        }

        $stream = [System.IO.File]::Open($f, 'Open', 'Read', 'None')
        try {
            { Assert-FileIsLocked $f } | Should -Not -Throw
            { Assert-FileIsNotLocked $f } | Should -Throw '*held open*'
        }
        finally {
            $stream.Dispose()
        }
    }
}
