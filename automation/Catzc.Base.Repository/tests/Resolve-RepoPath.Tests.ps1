Describe 'Resolve-RepoPath' -Tag 'L0', 'logic' {
    BeforeEach {
        $script:root = [IO.Path]::GetFullPath((Join-Path ([IO.Path]::GetTempPath()) ('catzc-root-' + [Guid]::NewGuid())))
        Mock Get-RepositoryRoot { $script:root } -ModuleName Catzc.Base.Repository
    }

    It 'resolves a repo-relative path against the repository root, not $PWD' {
        Mock Get-OutputRoot { Join-Path $script:root 'out' } -ModuleName Catzc.Base.Repository
        $expected = [IO.Path]::GetFullPath((Join-Path $script:root 'automation/mod/file.ps1'))
        Resolve-RepoPath 'automation/mod/file.ps1' | Should -Be $expected
    }

    It 'returns an already-absolute path unchanged' {
        Mock Get-OutputRoot { Join-Path $script:root 'out' } -ModuleName Catzc.Base.Repository
        $abs = [IO.Path]::GetFullPath((Join-Path ([IO.Path]::GetTempPath()) 'somewhere/main.json'))
        Resolve-RepoPath $abs | Should -Be $abs
    }

    It 'resolves the out/ sentinel against the output root (local: under the repo)' {
        $outRoot = Join-Path $script:root 'out'
        Mock Get-OutputRoot { $outRoot } -ModuleName Catzc.Base.Repository
        $expected = [IO.Path]::GetFullPath((Join-Path $outRoot 'template/sample/main.json'))
        Resolve-RepoPath 'out/template/sample/main.json' | Should -Be $expected
    }

    It 'resolves the out/ sentinel against an external output root (pipeline staging)' {
        $outRoot = [IO.Path]::GetFullPath((Join-Path ([IO.Path]::GetTempPath()) ('catzc-staging-' + [Guid]::NewGuid())))
        Mock Get-OutputRoot { $outRoot } -ModuleName Catzc.Base.Repository
        $expected = [IO.Path]::GetFullPath((Join-Path $outRoot 'template/sample/main.json'))
        Resolve-RepoPath 'out/template/sample/main.json' | Should -Be $expected
    }

    It 'round-trips an output artifact path through ConvertTo-RepoRelativePath' {
        $outRoot = [IO.Path]::GetFullPath((Join-Path ([IO.Path]::GetTempPath()) ('catzc-staging-' + [Guid]::NewGuid())))
        Mock Get-OutputRoot { $outRoot } -ModuleName Catzc.Base.Repository
        $original = [IO.Path]::GetFullPath((Join-Path $outRoot 'template/sample/main.json'))
        $relative = ConvertTo-RepoRelativePath $original
        $relative | Should -Be 'out/template/sample/main.json'
        Resolve-RepoPath $relative | Should -Be $original
    }

    It 'round-trips a repo source path through ConvertTo-RepoRelativePath' {
        Mock Get-OutputRoot { Join-Path $script:root 'out' } -ModuleName Catzc.Base.Repository
        $original = [IO.Path]::GetFullPath((Join-Path $script:root 'automation/mod/file.ps1'))
        $relative = ConvertTo-RepoRelativePath $original
        $relative | Should -Be 'automation/mod/file.ps1'
        Resolve-RepoPath $relative | Should -Be $original
    }
}
