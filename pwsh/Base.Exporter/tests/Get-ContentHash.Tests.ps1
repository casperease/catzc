Describe 'Get-ContentHash' -Tag 'L0', 'logic' {
    BeforeEach {
        $script:tree = Join-Path $TestDrive ([System.Guid]::NewGuid())
        [System.IO.Directory]::CreateDirectory((Join-Path $tree 'sub')) | Out-Null
        [System.IO.File]::WriteAllText((Join-Path $tree 'a.txt'), "alpha`n")
        [System.IO.File]::WriteAllText((Join-Path $tree 'sub/b.txt'), "beta`n")
    }

    It 'returns 64 lowercase hex chars' {
        Get-ContentHash -Path $tree | Should -Match '^[0-9a-f]{64}$'
    }

    It 'is deterministic — the same tree hashes the same twice' {
        (Get-ContentHash -Path $tree) | Should -Be (Get-ContentHash -Path $tree)
    }

    It 'is EOL-insensitive — CRLF and LF content yield the same hash' {
        $lf = Get-ContentHash -Path $tree
        [System.IO.File]::WriteAllText((Join-Path $tree 'a.txt'), "alpha`r`n")
        Get-ContentHash -Path $tree | Should -Be $lf
    }

    It 're-keys when file content changes' {
        $before = Get-ContentHash -Path $tree
        [System.IO.File]::WriteAllText((Join-Path $tree 'a.txt'), "gamma`n")
        Get-ContentHash -Path $tree | Should -Not -Be $before
    }

    It 're-keys when a file is renamed (the path is part of the fold)' {
        $before = Get-ContentHash -Path $tree
        [System.IO.File]::Move((Join-Path $tree 'a.txt'), (Join-Path $tree 'renamed.txt'))
        Get-ContentHash -Path $tree | Should -Not -Be $before
    }

    It 'throws on a missing path' {
        { Get-ContentHash -Path (Join-Path $TestDrive 'does-not-exist') } | Should -Throw
    }

    It 'omits an excluded file so a hash-carrying sidecar does not change the hash' {
        $before = Get-ContentHash -Path $tree
        [System.IO.File]::WriteAllText((Join-Path $tree 'build.json'), '{ "contentHash": "x" }')
        Get-ContentHash -Path $tree -Exclude 'build.json' | Should -Be $before
    }
}
