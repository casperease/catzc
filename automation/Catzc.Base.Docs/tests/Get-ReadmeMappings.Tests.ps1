# Get-ReadmeMappings is private, so it is exercised through the module (InModuleScope, per ADR-TEST:11).
Describe 'Get-ReadmeMappings' -Tag 'L0', 'logic' {
    BeforeAll {
        # Fixture repo: automation/<modules> + a dot-dir; reference sources for two of the three modules.
        $script:root = Join-Path $TestDrive ([guid]::NewGuid())
        foreach ($d in 'automation/Catzc.Azure.DevOps', 'automation/Catzc.Base.Files', 'automation/Catzc.NoDoc', 'automation/.vendor', 'docs/references/automation') {
            [System.IO.Directory]::CreateDirectory((Join-Path $script:root $d)) | Out-Null
        }
        [System.IO.File]::WriteAllText((Join-Path $script:root 'docs/references/automation/catzc-azure-devops.md'), '# x')
        [System.IO.File]::WriteAllText((Join-Path $script:root 'docs/references/automation/catzc-base-files.md'), '# x')
    }

    It 'derives a kebab source per matched non-dot folder whose source exists' {
        InModuleScope Catzc.Base.Docs -Parameters @{ Root = $script:root } {
            param($Root)
            $config = [pscustomobject]@{
                patterns = @([pscustomobject]@{ glob = 'automation/*'; source = 'docs/references/automation/{kebab}.md' })
                mappings = @()
            }
            $result = Get-ReadmeMappings -Config $config -RepositoryRoot $Root
            @($result.folder) | Should -Contain 'automation/Catzc.Azure.DevOps'
            @($result.folder) | Should -Contain 'automation/Catzc.Base.Files'
            ($result | Where-Object folder -EQ 'automation/Catzc.Azure.DevOps').source |
                Should -Be 'docs/references/automation/catzc-azure-devops.md'
        }
    }

    It 'skips a matched folder whose derived source does not exist' {
        InModuleScope Catzc.Base.Docs -Parameters @{ Root = $script:root } {
            param($Root)
            $config = [pscustomobject]@{
                patterns = @([pscustomobject]@{ glob = 'automation/*'; source = 'docs/references/automation/{kebab}.md' })
                mappings = @()
            }
            $result = Get-ReadmeMappings -Config $config -RepositoryRoot $Root
            @($result.folder) | Should -Not -Contain 'automation/Catzc.NoDoc'
        }
    }

    It 'excludes dot-prefixed folders from a /* glob' {
        InModuleScope Catzc.Base.Docs -Parameters @{ Root = $script:root } {
            param($Root)
            $config = [pscustomobject]@{
                patterns = @([pscustomobject]@{ glob = 'automation/*'; source = 'docs/references/automation/{kebab}.md' })
                mappings = @()
            }
            $result = Get-ReadmeMappings -Config $config -RepositoryRoot $Root
            @($result.folder) | Should -Not -Contain 'automation/.vendor'
        }
    }

    It 'lets an explicit mapping win over a pattern that also matches the folder' {
        InModuleScope Catzc.Base.Docs -Parameters @{ Root = $script:root } {
            param($Root)
            $config = [pscustomobject]@{
                patterns = @([pscustomobject]@{ glob = 'automation/*'; source = 'docs/references/automation/{kebab}.md' })
                mappings = @([pscustomobject]@{ folder = 'automation/Catzc.Azure.DevOps'; source = 'docs/custom/override.md' })
            }
            $result = Get-ReadmeMappings -Config $config -RepositoryRoot $Root
            ($result | Where-Object folder -EQ 'automation/Catzc.Azure.DevOps').source | Should -Be 'docs/custom/override.md'
        }
    }

    It 'throws on an unsupported glob (only a trailing /* is supported)' {
        # No Root plumbing: the glob-shape check throws before RepositoryRoot is ever read, so a literal
        # placeholder root is enough here.
        InModuleScope Catzc.Base.Docs {
            $config = [pscustomobject]@{
                patterns = @([pscustomobject]@{ glob = 'automation/**/deep'; source = 'x/{kebab}.md' })
                mappings = @()
            }
            { Get-ReadmeMappings -Config $config -RepositoryRoot 'x' } | Should -Throw '*Only a trailing*'
        }
    }
}
