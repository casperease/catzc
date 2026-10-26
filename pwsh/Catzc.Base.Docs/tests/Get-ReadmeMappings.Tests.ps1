<#
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-docs/tests/Get-ReadmeMappings.Tests.ps1.md"
  header: "generated"
---
#>

Describe 'Get-ReadmeMappings' -Tag 'L0', 'logic' {
    BeforeAll {
        # The source-tree guard is its own unit (below); here the fixture stands in for the source tree in either run
        # mode.
        Mock Assert-SourceTree -ModuleName Catzc.Base.Docs { }
        $script:root = Join-Path $TestDrive ([guid]::NewGuid())
        foreach ($d in 'widgets/Catzc.Azure.DevOps', 'widgets/Catzc.Base.Files', 'widgets/Catzc.NoDoc',
            'widgets/.vendor', 'docs/references/pwsh') {
            [System.IO.Directory]::CreateDirectory((Join-Path $script:root $d)) | Out-Null
        }
        [System.IO.File]::WriteAllText((Join-Path $script:root 'docs/references/pwsh/catzc-azure-dev-ops.md'), '# x')
        [System.IO.File]::WriteAllText((Join-Path $script:root 'docs/references/pwsh/catzc-base-files.md'), '# x')
    }

    It 'derives a kebab source per matched non-dot folder whose source exists' {
        InModuleScope Catzc.Base.Docs -Parameters @{ Root = $script:root } {
            param($Root)
            $config = [pscustomobject]@{
                patterns = @([pscustomobject]@{ glob = 'widgets/*'; source = 'docs/references/pwsh/{kebab}.md' })
                mappings = @()
            }
            $result = Get-ReadmeMappings -Config $config -RepositoryRoot $Root
            @($result.folder) | Should -Contain 'widgets/Catzc.Azure.DevOps'
            @($result.folder) | Should -Contain 'widgets/Catzc.Base.Files'
            ($result | Where-Object folder -EQ 'widgets/Catzc.Azure.DevOps').source |
                Should -Be 'docs/references/pwsh/catzc-azure-dev-ops.md'
        }
    }

    It 'derives a {name} source from the folder name as written, as a python package''s article is named' {
        InModuleScope Catzc.Base.Docs -Parameters @{ Root = $script:root } {
            param($Root)
            [System.IO.Directory]::CreateDirectory((Join-Path $Root 'gadgets/catzc_widget_kit')) | Out-Null
            [System.IO.Directory]::CreateDirectory((Join-Path $Root 'docs/references/gadgets')) | Out-Null
            [System.IO.File]::WriteAllText((Join-Path $Root 'docs/references/gadgets/catzc_widget_kit.md'), '# x')
            $config = [pscustomobject]@{
                patterns = @([pscustomobject]@{ glob = 'gadgets/*'; source = 'docs/references/gadgets/{name}.md' })
                mappings = @()
            }
            $result = Get-ReadmeMappings -Config $config -RepositoryRoot $Root
            ($result | Where-Object folder -EQ 'gadgets/catzc_widget_kit').source |
                Should -Be 'docs/references/gadgets/catzc_widget_kit.md'
        }
    }

    It 'skips a matched folder whose derived source does not exist' {
        InModuleScope Catzc.Base.Docs -Parameters @{ Root = $script:root } {
            param($Root)
            $config = [pscustomobject]@{
                patterns = @([pscustomobject]@{ glob = 'widgets/*'; source = 'docs/references/pwsh/{kebab}.md' })
                mappings = @()
            }
            $result = Get-ReadmeMappings -Config $config -RepositoryRoot $Root
            @($result.folder) | Should -Not -Contain 'widgets/Catzc.NoDoc'
        }
    }

    It 'returns under -Missing exactly the matched folders whose derived source does not exist' {
        InModuleScope Catzc.Base.Docs -Parameters @{ Root = $script:root } {
            param($Root)
            $config = [pscustomobject]@{
                patterns = @([pscustomobject]@{ glob = 'widgets/*'; source = 'docs/references/pwsh/{kebab}.md' })
                mappings = @()
            }
            $missing = @(Get-ReadmeMappings -Config $config -RepositoryRoot $Root -Missing)
            @($missing.folder) | Should -Be @('widgets/Catzc.NoDoc')
            $missing[0].source | Should -Be 'docs/references/pwsh/catzc-no-doc.md'
        }
    }

    It 'excludes dot-prefixed folders from a /* glob' {
        InModuleScope Catzc.Base.Docs -Parameters @{ Root = $script:root } {
            param($Root)
            $config = [pscustomobject]@{
                patterns = @([pscustomobject]@{ glob = 'widgets/*'; source = 'docs/references/pwsh/{kebab}.md' })
                mappings = @()
            }
            $result = Get-ReadmeMappings -Config $config -RepositoryRoot $Root
            @($result.folder) | Should -Not -Contain 'widgets/.vendor'
        }
    }

    It 'fails when a pattern names a folder the tree does not have, instead of matching nothing' {
        $config = [pscustomobject]@{
            patterns = @([pscustomobject]@{ glob = 'sprockets/*'; source = 'docs/references/pwsh/{kebab}.md' })
            mappings = @()
        }
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
                patterns = @([pscustomobject]@{ glob = 'widgets/*'; source = 'docs/references/pwsh/{kebab}.md' })
                mappings = @([pscustomobject]@{ folder = 'widgets/Catzc.Azure.DevOps'; source = 'docs/custom/override.md' })
            }
            $result = Get-ReadmeMappings -Config $config -RepositoryRoot $Root
            ($result | Where-Object folder -EQ 'widgets/Catzc.Azure.DevOps').source |
                Should -Be 'docs/custom/override.md'
        }
    }

    It 'throws on an unsupported glob (only a trailing /* is supported)' {
        InModuleScope Catzc.Base.Docs {
            $config = [pscustomobject]@{
                patterns = @([pscustomobject]@{ glob = 'widgets/**/deep'; source = 'x/{kebab}.md' })
                mappings = @()
            }
            { Get-ReadmeMappings -Config $config -RepositoryRoot 'x' } | Should -Throw '*Only a trailing*'
        }
    }
}

Describe 'Get-ReadmeMappings source-tree guard' -Tag 'L0', 'logic' {
    It 'refuses before expanding any glob when the session runs a built package' {
        Mock Assert-SourceTree -ModuleName Catzc.Base.Docs { throw 'Get-ReadmeMappings operates on the catzc source tree' }
        InModuleScope Catzc.Base.Docs {
            $config = [pscustomobject]@{
                patterns = @([pscustomobject]@{ glob = 'widgets/*'; source = 'docs/widgets/{kebab}.md' })
                mappings = @()
            }
            { Get-ReadmeMappings -Config $config -RepositoryRoot 'x' } | Should -Throw '*source tree*'
        }
    }
}
