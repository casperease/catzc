Describe 'Get-CatzcContentHash' -Tag 'L0', 'logic' {
    BeforeEach {
        $script:tree = Join-Path $TestDrive ([System.Guid]::NewGuid())
        [System.IO.Directory]::CreateDirectory((Join-Path $tree 'sub')) | Out-Null
        [System.IO.File]::WriteAllText((Join-Path $tree 'a.txt'), "alpha`n")
        [System.IO.File]::WriteAllText((Join-Path $tree 'sub/b.txt'), "beta`n")
    }

    It 'returns 64 lowercase hex chars' {
        Get-CatzcContentHash -Path $tree | Should -Match '^[0-9a-f]{64}$'
    }

    It 'is deterministic — the same tree hashes the same twice' {
        (Get-CatzcContentHash -Path $tree) | Should -Be (Get-CatzcContentHash -Path $tree)
    }

    It 'is EOL-insensitive — CRLF and LF content yield the same hash' {
        $lf = Get-CatzcContentHash -Path $tree
        [System.IO.File]::WriteAllText((Join-Path $tree 'a.txt'), "alpha`r`n")
        Get-CatzcContentHash -Path $tree | Should -Be $lf
    }

    It 're-keys when file content changes' {
        $before = Get-CatzcContentHash -Path $tree
        [System.IO.File]::WriteAllText((Join-Path $tree 'a.txt'), "gamma`n")
        Get-CatzcContentHash -Path $tree | Should -Not -Be $before
    }

    It 're-keys when a file is renamed (the path is part of the fold)' {
        $before = Get-CatzcContentHash -Path $tree
        [System.IO.File]::Move((Join-Path $tree 'a.txt'), (Join-Path $tree 'renamed.txt'))
        Get-CatzcContentHash -Path $tree | Should -Not -Be $before
    }

    It 'throws on a missing path' {
        { Get-CatzcContentHash -Path (Join-Path $TestDrive 'does-not-exist') } | Should -Throw
    }

    It 'omits an excluded file so a hash-carrying sidecar does not change the hash' {
        $before = Get-CatzcContentHash -Path $tree
        [System.IO.File]::WriteAllText((Join-Path $tree 'build.json'), '{ "contentHash": "x" }')
        Get-CatzcContentHash -Path $tree -Exclude 'build.json' | Should -Be $before
    }
}
