# The globs.yml registry gate: strict shape (unknown keys rejected), every entry a valid GlobSet, and the
# self-exclusion rule — no globset may have a trigger file or the config itself as a member (ADR-GLOBS:6).
Describe 'GlobsConfig' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:make = {
            param([hashtable] $globsets)
            [Catzc.Base.Globs.GlobsConfig]::new(@{ globsets = $globsets })
        }
    }

    Context 'a valid registry' {
        It 'constructs and exposes the sets with lookup' {
            $c = & $script:make @{
                'automation' = @{ description = 'the automation layer'; include = @('automation/**', 'importer.ps1') }
                'apex'       = @{ description = 'the apex unit'; include = @('infrastructure/**'); exclude = @('**/*.md') }
            }
            $c.globsets.Count | Should -Be 2
            $c.Names | Should -Contain 'automation'
            $c.Contains('apex') | Should -BeTrue
            $c.Contains('nope') | Should -BeFalse
            $c.Get('apex').TriggerPath | Should -Be '.triggers/apex.sha256'
            $c.Get('apex').Matches('infrastructure/x/readme.md') | Should -BeFalse
        }

        It 'throws a named error on an unknown set lookup' {
            $c = & $script:make @{ unit = @{ description = 'd'; include = @('src/**') } }
            { $c.Get('missing') } | Should -Throw "*no globset named 'missing'*"
        }
    }

    Context 'strict shape' {
        It 'rejects <why>' -ForEach @(
            @{ why = 'a missing globsets map'; block = { [Catzc.Base.Globs.GlobsConfig]::new(@{}) } }
            @{ why = 'an empty globsets map'; block = { [Catzc.Base.Globs.GlobsConfig]::new(@{ globsets = @{} }) } }
            @{ why = 'an unknown top-level key'; block = { [Catzc.Base.Globs.GlobsConfig]::new(@{ globsets = @{ u = @{ description = 'd'; include = @('a/**') } }; extra = 1 }) } }
            @{ why = 'an unknown per-set key'; block = { [Catzc.Base.Globs.GlobsConfig]::new(@{ globsets = @{ u = @{ description = 'd'; include = @('a/**'); owner = 'x' } } }) } }
            @{ why = 'a non-mapping set entry'; block = { [Catzc.Base.Globs.GlobsConfig]::new(@{ globsets = @{ u = 'not-a-map' } }) } }
            @{ why = 'a set with no include'; block = { [Catzc.Base.Globs.GlobsConfig]::new(@{ globsets = @{ u = @{ description = 'd' } } }) } }
            @{ why = 'a set with no description'; block = { [Catzc.Base.Globs.GlobsConfig]::new(@{ globsets = @{ u = @{ include = @('a/**') } } }) } }
            @{ why = 'a non-kebab set name'; block = { [Catzc.Base.Globs.GlobsConfig]::new(@{ globsets = @{ MyUnit = @{ description = 'd'; include = @('a/**') } } }) } }
        ) {
            $block | Should -Throw
        }

        It 'collects several errors into one failure' {
            {
                & $script:make @{
                    'BadName' = @{ description = 'd'; include = @('a/**') }
                    'no-desc' = @{ include = @('a/**') }
                }
            } | Should -Throw '*validation failed*'
        }
    }

    Context 'self-exclusion (ADR-GLOBS:6)' {
        It 'rejects a set matching its own trigger file' {
            { & $script:make @{ unit = @{ description = 'd'; include = @('.triggers/unit.sha256') } } } |
                Should -Throw '*ADR-GLOBS:6*'
        }

        It "rejects a set matching another set's trigger file" {
            {
                & $script:make @{
                    'a-unit' = @{ description = 'd'; include = @('src/**') }
                    'b-unit' = @{ description = 'd'; include = @('.triggers/a-unit.sha256') }
                }
            } | Should -Throw '*ADR-GLOBS:6*'
        }

        It 'rejects a catch-all include via the canary probe' {
            { & $script:make @{ unit = @{ description = 'd'; include = @('**') } } } |
                Should -Throw '*ADR-GLOBS:6*'
        }

        It 'accepts a set including the config itself — an ordinary tracked file' {
            $c = & $script:make @{ unit = @{ description = 'd'; include = @('automation/Catzc.Base.Globs/configs/*.yml') } }
            $c.Get('unit').Matches('automation/Catzc.Base.Globs/configs/globs.yml') | Should -BeTrue
        }

        It 'accepts a catch-all whose exclude carves out .triggers/' {
            $c = & $script:make @{
                everything = @{
                    description = 'the whole tree'
                    include     = @('**')
                    exclude     = @('.triggers/**')
                }
            }
            $c.Get('everything').Matches('docs/index.md') | Should -BeTrue
            $c.Get('everything').Matches('automation/Catzc.Base.Globs/configs/globs.yml') | Should -BeTrue
            $c.Get('everything').Matches('.triggers/everything.sha256') | Should -BeFalse
        }
    }
}
