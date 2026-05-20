Describe 'Clear-TempFolders' -Tag 'L0', 'logic' {
    # Always target a fixture folder under $TestDrive via -Path — never the real temp.

    It 'removes all top-level entries (files and directories) from the folder' {
        $folder = Join-Path $TestDrive ([Guid]::NewGuid())
        New-Item -ItemType Directory -Path $folder | Out-Null
        1..3 | ForEach-Object { Set-Content -Path (Join-Path $folder "file$_.tmp") -Value 'x' }
        New-Item -ItemType Directory -Path (Join-Path $folder 'subdir') | Out-Null
        Set-Content -Path (Join-Path $folder 'subdir/nested.txt') -Value 'y'

        $result = Clear-TempFolders -Path $folder

        @(Get-ChildItem -LiteralPath $folder -Force) | Should -HaveCount 0
        $result.Removed | Should -Be 4   # 3 files + 1 dir
        $result.Skipped | Should -Be 0
    }

    It 'leaves a locked file in place and counts it as skipped' {
        # FileShare.None is a MANDATORY lock only on Windows; on Unix it is advisory and does not block
        # delete, so the "locked" file would be removed and this case cannot be set up.
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

        # The third entry is the same folder with a trailing separator (dedup must canonicalize it away). Use
        # the platform separator — a hardcoded '\' is a literal filename char on Unix, i.e. a DIFFERENT path.
        $result = Clear-TempFolders -Path @($folder, $folder, ($folder + [System.IO.Path]::DirectorySeparatorChar))

        $result.Removed | Should -Be 1
        $result.Folders | Should -HaveCount 1
    }
}
