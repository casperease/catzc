# Validates the compiled DocsConfig / DocMapping / DocPattern types directly — the constructor is the gate
# that stops a malformed or duplicated readme.yml registry from ever producing an instance.
Describe 'DocsConfig' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:make = {
            param([hashtable] $raw) [Catzc.Base.Docs.DocsConfig]::new($raw)
        }
    }

    It 'constructs and exposes valid mappings in registry order' {
        $c = & $script:make @{
            mappings = @(
                @{ folder = 'a'; source = 'docs/readme/a.md' }
                @{ folder = 'b'; source = 'docs/readme/b.md' }
            )
        }
        $c.mappings.Count | Should -Be 2
        $c.mappings[0].folder | Should -Be 'a'
        $c.mappings[1].source | Should -Be 'docs/readme/b.md'
        $c.patterns.Count | Should -Be 0
    }

    It 'constructs from patterns alone (no mappings)' {
        $c = & $script:make @{ patterns = @(@{ glob = 'automation/*'; source = 'docs/references/automation/{kebab}.md' }) }
        $c.patterns.Count | Should -Be 1
        $c.patterns[0].glob | Should -Be 'automation/*'
        $c.mappings.Count | Should -Be 0
    }

    It 'constructs from patterns and mappings together' {
        $c = & $script:make @{
            patterns = @(@{ glob = 'automation/*'; source = 'docs/references/automation/{kebab}.md' })
            mappings = @(@{ folder = 'pipelines'; source = 'docs/references/pipelines.md' })
        }
        $c.patterns.Count | Should -Be 1
        $c.mappings.Count | Should -Be 1
    }

    It 'throws when neither patterns nor mappings has an entry' {
        { & $script:make @{ mappings = @() } } | Should -Throw '*at least one*'
        { & $script:make @{} } | Should -Throw '*at least one*'
    }

    It 'throws on a duplicate target folder' {
        {
            & $script:make @{
                mappings = @(
                    @{ folder = 'dup'; source = 'docs/readme/a.md' }
                    @{ folder = 'dup'; source = 'docs/readme/b.md' }
                )
            }
        } | Should -Throw '*duplicate target folder*'
    }

    It 'throws when a mapping is missing a required key' {
        { & $script:make @{ mappings = @(@{ folder = 'a' }) } } | Should -Throw '*source is required*'
    }

    It 'throws when a pattern is missing a required key' {
        { & $script:make @{ patterns = @(@{ glob = 'automation/*' }) } } | Should -Throw '*source is required*'
    }
}
