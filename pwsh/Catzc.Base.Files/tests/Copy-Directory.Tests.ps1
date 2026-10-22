Describe 'Copy-Directory' -Tag 'L0', 'logic' {
    BeforeEach {
        $script:src = Join-Path $TestDrive ([Guid]::NewGuid())
        $script:dst = Join-Path $TestDrive ([Guid]::NewGuid())
        New-Item -ItemType Directory -Path (Join-Path $script:src 'sub/deep') -Force | Out-Null
        Set-Content (Join-Path $script:src 'root.txt') 'r'
        Set-Content (Join-Path $script:src 'sub/a.txt') 'a'
        Set-Content (Join-Path $script:src 'sub/deep/b.txt') 'b'
    }

    It 'copies the whole tree into a new destination' {
        Copy-Directory $script:src $script:dst
        Get-Content (Join-Path $script:dst 'root.txt') | Should -Be 'r'
        Get-Content (Join-Path $script:dst 'sub/a.txt') | Should -Be 'a'
        Get-Content (Join-Path $script:dst 'sub/deep/b.txt') | Should -Be 'b'
    }

    It 'mirrors contents into the destination root (not nested under the source name)' {
        Copy-Directory $script:src $script:dst
        # The destination directly contains root.txt — the source folder name is not a level in the copy.
        Join-Path $script:dst 'root.txt' | Should -Exist
        Join-Path $script:dst (Split-Path $script:src -Leaf) | Should -Not -Exist
    }

    It 'preserves empty subdirectories' {
        New-Item -ItemType Directory -Path (Join-Path $script:src 'empty') -Force | Out-Null
        Copy-Directory $script:src $script:dst
        Join-Path $script:dst 'empty' | Should -Exist
    }

    It 'overwrites existing files in the destination' {
        New-Item -ItemType Directory -Path $script:dst -Force | Out-Null
        Set-Content (Join-Path $script:dst 'root.txt') 'stale'
        Copy-Directory $script:src $script:dst
        Get-Content (Join-Path $script:dst 'root.txt') | Should -Be 'r'
    }

    It 'creates the destination when it does not exist' {
        $script:dst | Should -Not -Exist
        Copy-Directory $script:src $script:dst
        $script:dst | Should -Exist
    }

    It 'throws when the source directory does not exist' {
        { Copy-Directory (Join-Path $TestDrive 'nope') $script:dst } | Should -Throw '*does not exist*'
    }
}
