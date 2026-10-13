# L2: drives real git against a throwaway repository that holds every working-tree state a snapshot must
# reproduce — staged, unstaged, staged-then-edited, untracked, deleted, ignored — plus LF bytes under
# core.autocrlf=true (a checkout would rewrite them as CRLF; the snapshot must not).
Describe 'New-RepositorySnapshot' -Tag 'L2', 'logic' {
    BeforeAll {
        Mock Write-Message { } -ModuleName Catzc.Base.Git

        $script:source = Join-Path ([System.IO.Path]::GetTempPath()) ('catzc-snapsrc-' + [guid]::NewGuid().ToString('N').Substring(0, 12))
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
        foreach ($relative in 'widget.txt', 'gadget/staged.txt', 'gadget/both.txt', 'untouched.txt', 'fresh/untracked.txt') {
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

    It 'throws and removes the half-built snapshot when its status differs from the source' {
        $destination = Join-Path ([System.IO.Path]::GetTempPath()) ('catzc-snapbad-' + [guid]::NewGuid().ToString('N').Substring(0, 12))
        Mock Invoke-Executable {
            [pscustomobject]@{ ExitCode = 0; Output = '? phantom.txt' }
        } -ModuleName Catzc.Base.Git -ParameterFilter { $Command -like '*status --porcelain=v2*' -and $Command -like "*$destination*" }

        { New-RepositorySnapshot -SourceRoot $script:source -Destination $destination } | Should -Throw '*does not match its source*'
        [System.IO.Directory]::Exists($destination) | Should -BeFalse
    }

    It 'refuses an existing destination' {
        { New-RepositorySnapshot -SourceRoot $script:source -Destination $script:snapshot.Path } | Should -Throw '*already exists*'
    }

    It 'is deleted by Remove-RepositorySnapshot' {
        $extra = New-RepositorySnapshot -SourceRoot $script:source
        Remove-RepositorySnapshot $extra.Path
        [System.IO.Directory]::Exists($extra.Path) | Should -BeFalse
    }
}
