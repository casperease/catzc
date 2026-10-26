Describe 'Get-ReadmeMappings' -Tag 'L0', 'logic' {
    BeforeAll {
        Mock Assert-SourceTree -ModuleName Catzc.Base.Docs { }
        # A module folder's README is its module article, the page the comment-pages resolver derives.
        Mock Get-Config -ModuleName Catzc.Base.Docs -ParameterFilter { $Config -eq 'comment-pages' } {
            [Catzc.Base.CodeMeta.CommentPagesConfig]::new([ordered]@{ pages = @([ordered]@{ source = 'widgets/*'; docs = 'docs/references/widgets' }) })
        }
        $script:root = Join-Path $TestDrive ([guid]::NewGuid())
        foreach ($d in 'widgets/Azure.DevOps', 'widgets/Base.Files', 'widgets/NoDoc', 'widgets/.vendor',
            'docs/references/widgets/azure-dev-ops', 'docs/references/widgets/base-files') {
            [System.IO.Directory]::CreateDirectory((Join-Path $script:root $d)) | Out-Null
        }
        [System.IO.File]::WriteAllText((Join-Path $script:root 'docs/references/widgets/azure-dev-ops/index.md'), '# x')
        [System.IO.File]::WriteAllText((Join-Path $script:root 'docs/references/widgets/base-files/index.md'), '# x')
        $script:widgets = [pscustomobject]@{ patterns = @([pscustomobject]@{ glob = 'widgets/*' }); mappings = @() }
    }

    It 'takes each matched non-dot folder''s module article as its source, where the article exists' -Tag 'ADR-REPO-COMMENTS-COMMENTPAGEPLACE' {
        InModuleScope Catzc.Base.Docs -Parameters @{ Root = $script:root; Config = $script:widgets } {
            param($Root, $Config)
            $result = Get-ReadmeMappings -Config $Config -RepositoryRoot $Root
            @($result.folder) | Should -Be @('widgets/Azure.DevOps', 'widgets/Base.Files')
            ($result | Where-Object folder -EQ 'widgets/Azure.DevOps').source | Should -Be 'docs/references/widgets/azure-dev-ops/index.md'
        }
    }

    It 'returns under -Missing exactly the matched folders whose module article does not exist' {
        InModuleScope Catzc.Base.Docs -Parameters @{ Root = $script:root; Config = $script:widgets } {
            param($Root, $Config)
            $missing = @(Get-ReadmeMappings -Config $Config -RepositoryRoot $Root -Missing)
            @($missing.folder) | Should -Be @('widgets/NoDoc')
            $missing[0].source | Should -Be 'docs/references/widgets/no-doc/index.md'
        }
    }

    It 'fails when a pattern names a folder the tree does not have, instead of matching nothing' {
        $config = [pscustomobject]@{ patterns = @([pscustomobject]@{ glob = 'sprockets/*' }); mappings = @() }
        {
            InModuleScope Catzc.Base.Docs -Parameters @{ Root = $script:root; Config = $config } {
                param($Root, $Config)
                Get-ReadmeMappings -Config $Config -RepositoryRoot $Root
            }
        } | Should -Throw "*names 'sprockets', which is no folder*"
    }

    It 'lets an explicit mapping win over a pattern that also matches the folder' {
        InModuleScope Catzc.Base.Docs -Parameters @{ Root = $script:root } {
            param($Root)
            $config = [pscustomobject]@{
                patterns = @([pscustomobject]@{ glob = 'widgets/*' })
                mappings = @([pscustomobject]@{ folder = 'widgets/Azure.DevOps'; source = 'docs/custom/override.md' })
            }
            ($result = Get-ReadmeMappings -Config $config -RepositoryRoot $Root) | Out-Null
            ($result | Where-Object folder -EQ 'widgets/Azure.DevOps').source | Should -Be 'docs/custom/override.md'
        }
    }

    It 'throws on an unsupported glob (only a trailing /* is supported)' {
        InModuleScope Catzc.Base.Docs {
            $config = [pscustomobject]@{ patterns = @([pscustomobject]@{ glob = 'widgets/**/deep' }); mappings = @() }
            { Get-ReadmeMappings -Config $config -RepositoryRoot 'x' } | Should -Throw '*Only a trailing*'
        }
    }
}

Describe 'Get-ReadmeMappings source-tree guard' -Tag 'L0', 'logic' {
    It 'refuses before expanding any glob when the session runs a built package' {
        Mock Assert-SourceTree -ModuleName Catzc.Base.Docs { throw 'Get-ReadmeMappings operates on the catzc source tree' }
        InModuleScope Catzc.Base.Docs {
            $config = [pscustomobject]@{ patterns = @([pscustomobject]@{ glob = 'widgets/*' }); mappings = @() }
            { Get-ReadmeMappings -Config $config -RepositoryRoot 'x' } | Should -Throw '*source tree*'
        }
    }
}
