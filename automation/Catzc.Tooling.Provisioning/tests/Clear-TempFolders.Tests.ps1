<#
---
catzc:
  derived:
    path: automation/Catzc.Tooling.Provisioning/tests/Clear-TempFolders.Tests.ps1
    folder: tests
    name: clear-temp-folders-tests
    filetype: ps1
    kind: test
    language: powershell
    track: automation
    module: Catzc.Tooling.Provisioning
    moduletype: pwsh-folder
    catzc_bundle: azure
    relatives:
      page: docs/references/automation/catzc-tooling-provisioning/tests/Clear-TempFolders.Tests.ps1.md
---
#>

Describe 'Clear-TempFolders' -Tag 'L0', 'logic' {
    # Always target a fixture folder under $TestDrive via -Path — never the real temp.

    It 'removes all top-level entries (files and directories) from the folder' {
        $folder = Join-Path $TestDrive ([Guid]::NewGuid())
        New-Item -ItemType Directory -Path $folder | Out-Null
        1..3 | ForEach-Object { Set-Content -Path (Join-Path $folder "file$_.tmp") -Value 'x' }
        New-Item -ItemType Directory -Path (Join-Path $folder 'subdir') | Out-Null
        Set-Content -Path (Join-Path $folder 'subdir/nested.txt') -Value 'y'

        $result = Clear-TempFolders -Path $folder

        [System.IO.Directory]::EnumerateFileSystemEntries($folder).GetEnumerator().MoveNext() | Should -BeFalse
        $result.Removed | Should -Be 4   # 3 files + 1 dir
        $result.Skipped | Should -Be 0
    }

    It 'leaves a locked file in place and counts it as skipped' {
        if (-not $IsWindows) {
            Set-ItResult -Skipped -Because 'windows_only_file_lock'; return
        }

        $folder = Join-Path $TestDrive ([Guid]::NewGuid())
        New-Item -ItemType Directory -Path $folder | Out-Null
        Set-Content -Path (Join-Path $folder 'free.tmp') -Value 'x'
        $lockedPath = Join-Path $folder 'locked.tmp'
        Set-Content -Path $lockedPath -Value 'x'

        $handle = [System.IO.File]::Open($lockedPath, 'Open', 'Read', 'None')   # exclusive lock blocks delete
        try {
            $result = Clear-TempFolders -Path $folder
            Test-Path -LiteralPath $lockedPath | Should -BeTrue
            Join-Path $folder 'free.tmp' | Should -Not -Exist
            $result.Removed | Should -Be 1
            $result.Skipped | Should -Be 1
        }
        finally {
            $handle.Close()
        }
    }

    It 'deletes nothing under -DryRun but reports what it would remove' {
        $folder = Join-Path $TestDrive ([Guid]::NewGuid())
        New-Item -ItemType Directory -Path $folder | Out-Null
        Set-Content -Path (Join-Path $folder 'keep.tmp') -Value 'x'

        $result = Clear-TempFolders -Path $folder -DryRun

        Join-Path $folder 'keep.tmp' | Should -Exist
        $result.Removed | Should -Be 1
        $result.Skipped | Should -Be 0
    }

    It 'ignores a non-existent folder without throwing' {
        { Clear-TempFolders -Path (Join-Path $TestDrive 'does-not-exist') } | Should -Not -Throw
    }

    It 'de-duplicates repeated paths so an entry is counted once' {
        $folder = Join-Path $TestDrive ([Guid]::NewGuid())
        New-Item -ItemType Directory -Path $folder | Out-Null
        Set-Content -Path (Join-Path $folder 'once.tmp') -Value 'x'

        $result = Clear-TempFolders -Path @($folder, $folder, ($folder + [System.IO.Path]::DirectorySeparatorChar))

        $result.Removed | Should -Be 1
        $result.Folders | Should -HaveCount 1
    }
}
