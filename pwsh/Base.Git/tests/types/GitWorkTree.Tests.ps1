Describe 'Catzc.Base.Git.GitWorkTree' -Tag 'L0', 'logic' {
    It 'joins the .git folder and the snapshot marker onto a work tree, full paths' {
        $root = Join-Path $TestDrive 'widget-tree'
        [Catzc.Base.Git.GitWorkTree]::GitFolder($root) |
            Should -Be ([System.IO.Path]::GetFullPath((Join-Path $root '.git')))
        [Catzc.Base.Git.GitWorkTree]::SnapshotMarker($root) |
            Should -Be ([System.IO.Path]::GetFullPath((Join-Path $root '.git/catzc-snapshot.json')))
    }

    It 'calls a work tree a snapshot only while its marker exists' {
        $root = Join-Path $TestDrive 'gadget-tree'
        [System.IO.Directory]::CreateDirectory((Join-Path $root '.git')) | Out-Null
        [Catzc.Base.Git.GitWorkTree]::IsSnapshot($root) | Should -BeFalse
        [System.IO.File]::WriteAllText([Catzc.Base.Git.GitWorkTree]::SnapshotMarker($root), '{}')
        [Catzc.Base.Git.GitWorkTree]::IsSnapshot($root) | Should -BeTrue
    }

    It 'rejects an empty root' {
        { [Catzc.Base.Git.GitWorkTree]::GitFolder('') } | Should -Throw '*root must not be empty*'
    }
}
