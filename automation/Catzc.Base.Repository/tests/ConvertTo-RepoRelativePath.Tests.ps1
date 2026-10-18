Describe 'ConvertTo-RepoRelativePath' -Tag 'L0', 'logic' {
    BeforeEach {
        $script:root = [IO.Path]::GetFullPath((Join-Path ([IO.Path]::GetTempPath()) ('catzc-root-' + [Guid]::NewGuid())))
        Mock Get-RepositoryRoot { $script:root } -ModuleName Catzc.Base.Repository
    }

    Context 'output root under the repo (local devbox)' {
        BeforeEach {
            $script:outRoot = Join-Path $script:root 'out'
            Mock Get-OutputRoot { $script:outRoot } -ModuleName Catzc.Base.Repository
        }

        It 'anchors a path under the output root with the out/ sentinel' {
            $p = Join-Path $script:outRoot 'template/sample/main.json'
            ConvertTo-RepoRelativePath $p | Should -Be 'out/template/sample/main.json'
        }

        It 'uses a plain repo-relative form for a source path' {
            $p = Join-Path $script:root 'automation/mod/file.ps1'
            ConvertTo-RepoRelativePath $p | Should -Be 'automation/mod/file.ps1'
        }

        It 'has no rooted prefix on a relative result' {
            $p = Join-Path $script:root 'automation/mod/file.ps1'
            [IO.Path]::IsPathRooted((ConvertTo-RepoRelativePath $p)) | Should -BeFalse
        }

        It 'normalizes a path before relativizing' {
            $p = Join-Path $script:outRoot 'template/../template/sample/main.json'
            ConvertTo-RepoRelativePath $p | Should -Be 'out/template/sample/main.json'
        }
    }

    Context 'output root outside the repo (pipeline staging)' {
        BeforeEach {
            $script:outRoot = [IO.Path]::GetFullPath((Join-Path ([IO.Path]::GetTempPath()) ('catzc-staging-' + [Guid]::NewGuid())))
            Mock Get-OutputRoot { $script:outRoot } -ModuleName Catzc.Base.Repository
        }

        It 'still anchors an output artifact with out/ (portable across contexts, not degraded to absolute)' {
            $p = Join-Path $script:outRoot 'template/sample/main.json'
            ConvertTo-RepoRelativePath $p | Should -Be 'out/template/sample/main.json'
        }

        It 'keeps an absolute path that sits under neither root' {
            $outside = [IO.Path]::GetFullPath((Join-Path ([IO.Path]::GetTempPath()) ('catzc-other-' + [Guid]::NewGuid() + '/main.json')))
            ConvertTo-RepoRelativePath $outside | Should -Be $outside
        }
    }
}
