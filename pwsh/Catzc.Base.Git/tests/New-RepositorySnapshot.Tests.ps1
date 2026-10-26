<#
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-git/tests/New-RepositorySnapshot.Tests.ps1.md"
  header: "generated"
---
#>

Describe 'New-RepositorySnapshot' -Tag 'L2', 'logic' {
    BeforeAll {
        Mock Write-Message { } -ModuleName Catzc.Base.Git

        $script:source = Join-Path ([System.IO.Path]::GetTempPath()) ('catzc-snapshot-source-' + [guid]::NewGuid().ToString('N').Substring(0, 12))
        [System.IO.Directory]::CreateDirectory($script:source) | Out-Null
        $source = $script:source
        $write = {
            param($relative, $content)
            $path = Join-Path $source $relative
            [System.IO.Directory]::CreateDirectory([System.IO.Path]::GetDirectoryName($path)) | Out-Null
            [System.IO.File]::WriteAllText($path, $content)
        }

        & git -C $source init -b main *> $null
        & git -C $source config user.email 'widget@example.com' *> $null
        & git -C $source config user.name 'Widget' *> $null
        & git -C $source config commit.gpgsign false *> $null
        & git -C $source config core.autocrlf true *> $null

        & $write '.gitignore' "out/`n"
        & $write 'widget.txt' "widget v1`n"
        & $write 'gadget/staged.txt' "staged v1`n"
        & $write 'gadget/both.txt' "both v1`n"
        & $write 'gone.txt' "gone`n"
        & $write 'untouched.txt' "untouched`n"
        & git -C $source add -A *> $null
        & git -C $source commit -m 'seed' *> $null

        & $write 'widget.txt' "widget v2 (unstaged)`n"
        & $write 'gadget/staged.txt' "staged v2`n"
        & git -C $source add -- gadget/staged.txt *> $null
        & $write 'gadget/both.txt' "both v2 (staged)`n"
        & git -C $source add -- gadget/both.txt *> $null
        & $write 'gadget/both.txt' "both v3 (unstaged on top)`n"
        [System.IO.File]::Delete((Join-Path $source 'gone.txt'))
        & $write 'fresh/untracked.txt' "untracked`n"
        & $write 'out/build.log' "ignored`n"

        $script:snapshot = New-RepositorySnapshot -SourceRoot $source
        $script:statusOf = {
            param($root)
            @(& git --no-optional-locks -C $root status --porcelain=v2 --untracked-files=all)
        }
    }

    AfterAll {
        if ($script:snapshot) {
            Remove-RepositorySnapshot $script:snapshot.Path
        }
        if ($script:source -and (Test-Path $script:source)) {
            Remove-Item $script:source -Recurse -Force -ErrorAction SilentlyContinue
        }
    }

    It 'reproduces the source''s git status exactly — staged, unstaged, untracked, and deleted alike' {
        $sourceStatus = & $script:statusOf $script:source
        $sourceStatus.Count | Should -BeGreaterThan 3 -Because 'the fixture holds several working-tree states'
        (& $script:statusOf $script:snapshot.Path) | Should -Be $sourceStatus
    }

    It 'copies working-tree bytes exactly (LF stays LF under core.autocrlf=true)' {
        foreach ($relative in 'widget.txt', 'gadget/staged.txt', 'gadget/both.txt', 'untouched.txt',
            'fresh/untracked.txt') {
            $expected = [System.IO.File]::ReadAllBytes((Join-Path $script:source $relative))
            $actual = [System.IO.File]::ReadAllBytes((Join-Path $script:snapshot.Path $relative))
            [Convert]::ToHexString($actual) | Should -Be ([Convert]::ToHexString($expected)) -Because $relative
        }
    }

    It 'leaves ignored content and deleted files out' {
        [System.IO.File]::Exists((Join-Path $script:snapshot.Path 'out/build.log')) | Should -BeFalse
        [System.IO.File]::Exists((Join-Path $script:snapshot.Path 'gone.txt')) | Should -BeFalse
    }

    It 'reports its provenance and the change counts relative to HEAD' {
        $script:snapshot.SourceRoot | Should -Be ([System.IO.Path]::GetFullPath($script:source).TrimEnd('\', '/'))
        $script:snapshot.Commit | Should -Be ((& git -C $script:source rev-parse HEAD) | Out-String).Trim()
        $script:snapshot.Modified | Should -Be 3
        $script:snapshot.Untracked | Should -Be 1
        $script:snapshot.Deleted | Should -Be 1
    }

    It 'is frozen: a later edit in the source does not reach the snapshot' {
        [System.IO.File]::WriteAllText((Join-Path $script:source 'untouched.txt'), "edited after the snapshot`n")
        [System.IO.File]::ReadAllText((Join-Path $script:snapshot.Path 'untouched.txt')) | Should -Be "untouched`n"
    }

    It 'throws and removes the snapshot when its status keeps differing from the source, after announcing each rebuild' {
        $destination = Join-Path ([System.IO.Path]::GetTempPath()) ('catzc-snapshot-mismatch-' + [guid]::NewGuid().ToString('N').Substring(0, 12))
        Mock Invoke-Executable {
            [pscustomobject]@{ ExitCode = 0; Output = '? phantom.txt' }
        } -ModuleName Catzc.Base.Git -ParameterFilter { $Command -like '*status --porcelain=v2*' -and $Command -like "*$destination*" }

        { New-RepositorySnapshot -SourceRoot $script:source -Destination $destination -Attempts 2 } |
            Should -Throw '*does not match its source*after 2 attempt(s)*'
        [System.IO.Directory]::Exists($destination) | Should -BeFalse
        Should -Invoke Write-Message -ModuleName Catzc.Base.Git -Times 1 -Exactly -ParameterFilter { $Message -like '*rebuilding it (attempt 2 of 2)*' }
    }

    It 'rebuilds once when the source changed during the copy, and returns the verified snapshot' {
        $destination = Join-Path ([System.IO.Path]::GetTempPath()) ('catzc-snapshot-mismatch-' + [guid]::NewGuid().ToString('N').Substring(0, 12))
        # Only the first snapshot status differs; the filter stops matching after it, so the rebuild runs real git.
        $script:statusCalls = 0
        Mock Invoke-Executable {
            [pscustomobject]@{ ExitCode = 0; Output = '? phantom.txt' }
        } -ModuleName Catzc.Base.Git -ParameterFilter {
            $Command -like '*status --porcelain=v2*' -and $Command -like "*$destination*" -and ($script:statusCalls++ -eq 0)
        }

        try {
            $snapshot = New-RepositorySnapshot -SourceRoot $script:source -Destination $destination
            $snapshot.Path | Should -Be $destination
            [System.IO.File]::Exists((Join-Path $destination 'untouched.txt')) | Should -BeTrue
            Should -Invoke Write-Message -ModuleName Catzc.Base.Git -Times 1 -Exactly -ParameterFilter { $Message -like '*rebuilding it (attempt 2 of 3)*' }
        }
        finally {
            Remove-RepositorySnapshot -Path $destination
        }
    }

    It 'with -Committed holds HEAD alone: no staged, unstaged or untracked change, and the deleted file back' {
        $committed = New-RepositorySnapshot -SourceRoot $script:source -Committed
        try {
            $committed.Commit | Should -Be $script:snapshot.Commit
            @($committed.Modified, $committed.Untracked, $committed.Deleted) | Should -Be @(0, 0, 0)
            (& $script:statusOf $committed.Path) | Should -BeNullOrEmpty
            [System.IO.File]::ReadAllText((Join-Path $committed.Path 'widget.txt')).TrimEnd() | Should -Be 'widget v1'
            [System.IO.File]::ReadAllText((Join-Path $committed.Path 'gadget/both.txt')).TrimEnd() |
                Should -Be 'both v1'
            [System.IO.File]::Exists((Join-Path $committed.Path 'gone.txt')) | Should -BeTrue
            [System.IO.File]::Exists((Join-Path $committed.Path 'fresh/untracked.txt')) | Should -BeFalse
        }
        finally {
            Remove-RepositorySnapshot $committed.Path
        }
    }

    It 'names each folder as the source has it on disk, though the index keeps the case of a case-only rename' {
        $renamed = Join-Path ([System.IO.Path]::GetTempPath()) ('catzc-snapshot-case-' + [guid]::NewGuid().ToString('N').Substring(0, 12))
        $caseSnapshot = $null
        try {
            [System.IO.Directory]::CreateDirectory((Join-Path $renamed 'Widget.Gadget/Sprocket')) | Out-Null
            [System.IO.File]::WriteAllText((Join-Path $renamed 'Widget.Gadget/Sprocket/a.txt'), "a`n")
            & git -C $renamed init -b main *> $null
            & git -C $renamed config user.email 'widget@example.com' *> $null
            & git -C $renamed config user.name 'Widget' *> $null
            & git -C $renamed config commit.gpgsign false *> $null
            & git -C $renamed add -A *> $null
            & git -C $renamed commit -m 'seed' *> $null
            # A case-only rename on disk, through a neutral name so a case-insensitive file system takes it.
            [System.IO.Directory]::Move((Join-Path $renamed 'Widget.Gadget'), (Join-Path $renamed 'widget.tmp'))
            [System.IO.Directory]::Move((Join-Path $renamed 'widget.tmp'), (Join-Path $renamed 'widget.gadget'))

            $caseSnapshot = New-RepositorySnapshot -SourceRoot $renamed
            @([System.IO.Directory]::GetDirectories($caseSnapshot.Path) | ForEach-Object { [System.IO.Path]::GetFileName($_) } | Where-Object { $_ -ne '.git' }) |
                Should -BeExactly @('widget.gadget')
            [System.IO.File]::ReadAllText((Join-Path $caseSnapshot.Path 'widget.gadget/Sprocket/a.txt')) |
                Should -BeExactly "a`n"
        }
        finally {
            if ($caseSnapshot) {
                Remove-RepositorySnapshot $caseSnapshot.Path
            }
            Remove-Item $renamed -Recurse -Force -ErrorAction SilentlyContinue
        }
    }

    It 'refuses an existing destination' {
        { New-RepositorySnapshot -SourceRoot $script:source -Destination $script:snapshot.Path } |
            Should -Throw '*already exists*'
    }

    It 'is deleted by Remove-RepositorySnapshot' {
        $extra = New-RepositorySnapshot -SourceRoot $script:source
        Remove-RepositorySnapshot $extra.Path
        [System.IO.Directory]::Exists($extra.Path) | Should -BeFalse
    }
}
