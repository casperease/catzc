# cspell:ignore dedupe
# The globs.yml registry gate: strict shape (unknown keys rejected), every entry a valid GlobSet with a
# declared layer (ADR-FLOW-CD-GLOBS:7), and compose resolving acyclically to declared sets (ADR-FLOW-CD-GLOBS:8).
Describe 'GlobsConfig' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:make = {
            param([hashtable] $globsets)
            [Catzc.Base.Globs.GlobsConfig]::new(@{ globsets = $globsets })
        }
        # Render a set's flattened scan program as '+ pattern' / '- pattern' lines (ADR-FLOW-CD-GLOBS:4/8) — the
        # ordered membership program, the durable behaviour the removed marker rendering used to show.
        $script:program = {
            param($set)
            foreach ($rule in $set.ScanProgram()) {
                $op = if ($rule.Select) {
                    '+'
                }
                else {
                    '-'
                }
                "$op $($rule.Pattern.Pattern)"
            }
        }
    }

    Context 'a valid registry' {
        It 'constructs and exposes the sets with lookup' {
            # Neutral fixture globset names (widget/gadget), not the real loose-fileset/deployable-unit names (ADR-AUTO-TEST:3).
            $c = & $script:make @{
                'widget' = @{ description = 'the widget surface'; layer = 'loose-fileset'; include = @('src/**', 'main.ps1') }
                'gadget' = @{ description = 'the gadget unit'; layer = 'deployable-unit'; include = @('lib/**'); exclude = @('**/*.md') }
            }
            $c.globsets.Count | Should -Be 2
            $c.Names | Should -Contain 'widget'
            $c.Contains('gadget') | Should -BeTrue
            $c.Contains('nope') | Should -BeFalse
            $c.Get('gadget').Layer | Should -Be 'deployable-unit'
            $c.Get('gadget').Matches('lib/x/readme.md') | Should -BeFalse
        }

        It 'throws a named error on an unknown set lookup' {
            $c = & $script:make @{ unit = @{ description = 'd'; layer = 'loose-fileset'; include = @('src/**') } }
            { $c.Get('missing') } | Should -Throw "*no globset named 'missing'*"
        }

        It 'carries the pipeline binding and the verify scope' {
            $c = & $script:make @{
                unit = @{ description = 'd'; layer = 'deployable-unit'; include = @('src/**')
                    pipeline = 'cd-unit'; verify = @{ modules = @('Catzc.Azure.Templates'); level = 2 }
                }
            }
            $c.Get('unit').Pipeline | Should -Be 'cd-unit'
            $c.Get('unit').VerifyModules | Should -Be @('Catzc.Azure.Templates')
            $c.Get('unit').VerifyLevel | Should -Be 2
        }
    }

    Context 'composition (ADR-FLOW-CD-GLOBS:8)' {
        It 'unions the composed set into the effective membership' {
            $c = & $script:make @{
                'base' = @{ description = 'd'; layer = 'deployable-unit'; include = @('shared/**'); exclude = @('shared/private/**') }
                'unit' = @{ description = 'd'; layer = 'deployable-unit'; compose = @('base'); include = @('mine/**') }
            }
            $set = $c.Get('unit')
            $set.Matches('mine/a.txt') | Should -BeTrue
            $set.Matches('shared/a.txt') | Should -BeTrue
            $set.Matches('shared/private/a.txt') | Should -BeFalse -Because 'the composed set contributes its EFFECTIVE members'
            $set.Matches('other/a.txt') | Should -BeFalse
        }

        It 'flattens the composed surface into the scan program, own rules last (ADR-FLOW-CD-GLOBS:8)' {
            $c = & $script:make @{
                'base' = @{ description = 'd'; layer = 'deployable-unit'; include = @('shared/**'); exclude = @('shared/config/**') }
                'unit' = @{ description = 'd'; layer = 'deployable-unit'; compose = @('base'); include = @('mine/**'); pipeline = 'cd-unit' }
            }
            # base rules first, then unit's own rule last (own-rules-last)
            (& $script:program $c.Get('unit')) | Should -Be @('+ shared/**', '- shared/config/**', '+ mine/**')
            # the base set composes nothing, so its program is just its own rules
            (& $script:program $c.Get('base')) | Should -Be @('+ shared/**', '- shared/config/**')
        }

        It 'flattens transitively, each rule appearing once — dedupe keeps the last occurrence (ADR-FLOW-CD-GLOBS:8)' {
            $c = & $script:make @{
                'leaf' = @{ description = 'd'; layer = 'deployable-unit'; include = @('leaf/**') }
                'mid'  = @{ description = 'd'; layer = 'deployable-unit'; compose = @('leaf'); include = @('mid/**') }
                'top'  = @{ description = 'd'; layer = 'deployable-unit'; compose = @('mid', 'leaf'); include = @('top/**') }
            }
            # top composes [mid, leaf]; mid already pulls leaf. Raw: +leaf,+mid,+leaf,+top -> dedupe-last: +mid,+leaf,+top
            (& $script:program $c.Get('top')) | Should -Be @('+ mid/**', '+ leaf/**', '+ top/**')
        }

        It 'rejects a compose reference to an unknown set' {
            { & $script:make @{ unit = @{ description = 'd'; layer = 'deployable-unit'; compose = @('nope') } } } |
                Should -Throw '*unknown set*ADR-FLOW-CD-GLOBS:8*'
        }

        It 'rejects a self-compose' {
            { & $script:make @{ unit = @{ description = 'd'; layer = 'deployable-unit'; compose = @('unit') } } } |
                Should -Throw '*composes itself*'
        }

        It 'rejects a compose cycle' {
            {
                & $script:make @{
                    'a-unit' = @{ description = 'd'; layer = 'deployable-unit'; include = @('a/**'); compose = @('b-unit') }
                    'b-unit' = @{ description = 'd'; layer = 'deployable-unit'; include = @('b/**'); compose = @('a-unit') }
                }
            } | Should -Throw '*compose cycle*'
        }
    }

    Context 'strict shape' {
        It 'rejects <why>' -ForEach @(
            @{ why = 'a missing globsets map'; block = { [Catzc.Base.Globs.GlobsConfig]::new(@{}) } }
            @{ why = 'an empty globsets map'; block = { [Catzc.Base.Globs.GlobsConfig]::new(@{ globsets = @{} }) } }
            @{ why = 'an unknown top-level key'; block = { [Catzc.Base.Globs.GlobsConfig]::new(@{ globsets = @{ u = @{ description = 'd'; layer = 'loose-fileset'; include = @('a/**') } }; extra = 1 }) } }
            @{ why = 'an unknown per-set key'; block = { [Catzc.Base.Globs.GlobsConfig]::new(@{ globsets = @{ u = @{ description = 'd'; layer = 'loose-fileset'; include = @('a/**'); owner = 'x' } } }) } }
            @{ why = 'a non-mapping set entry'; block = { [Catzc.Base.Globs.GlobsConfig]::new(@{ globsets = @{ u = 'not-a-map' } }) } }
            @{ why = 'a set with neither include nor compose'; block = { [Catzc.Base.Globs.GlobsConfig]::new(@{ globsets = @{ u = @{ description = 'd'; layer = 'loose-fileset' } } }) } }
            @{ why = 'a set with no description'; block = { [Catzc.Base.Globs.GlobsConfig]::new(@{ globsets = @{ u = @{ layer = 'loose-fileset'; include = @('a/**') } } }) } }
            @{ why = 'a set with no layer'; block = { [Catzc.Base.Globs.GlobsConfig]::new(@{ globsets = @{ u = @{ description = 'd'; include = @('a/**') } } }) } }
            @{ why = "the derived-only 'module' layer"; block = { [Catzc.Base.Globs.GlobsConfig]::new(@{ globsets = @{ u = @{ description = 'd'; layer = 'module'; include = @('a/**') } } }) } }
            @{ why = 'a non-kebab set name'; block = { [Catzc.Base.Globs.GlobsConfig]::new(@{ globsets = @{ MyUnit = @{ description = 'd'; layer = 'loose-fileset'; include = @('a/**') } } }) } }
            @{ why = 'a verify without modules'; block = { [Catzc.Base.Globs.GlobsConfig]::new(@{ globsets = @{ u = @{ description = 'd'; layer = 'loose-fileset'; include = @('a/**'); verify = @{ level = 1 } } } }) } }
            @{ why = 'a verify with an out-of-range level'; block = { [Catzc.Base.Globs.GlobsConfig]::new(@{ globsets = @{ u = @{ description = 'd'; layer = 'loose-fileset'; include = @('a/**'); verify = @{ modules = @('M'); level = 9 } } } }) } }
            @{ why = 'a verify with an unknown key'; block = { [Catzc.Base.Globs.GlobsConfig]::new(@{ globsets = @{ u = @{ description = 'd'; layer = 'loose-fileset'; include = @('a/**'); verify = @{ modules = @('M'); level = 1; extra = 1 } } } }) } }
        ) {
            $block | Should -Throw
        }

        It 'collects several errors into one failure' {
            {
                & $script:make @{
                    'BadName' = @{ description = 'd'; layer = 'loose-fileset'; include = @('a/**') }
                    'no-desc' = @{ layer = 'loose-fileset'; include = @('a/**') }
                }
            } | Should -Throw '*validation failed*'
        }
    }

    Context 'the config file is an ordinary member' {
        It 'accepts a set including the config file itself — an ordinary tracked file, not an output' {
            $c = & $script:make @{ unit = @{ description = 'd'; layer = 'loose-fileset'; include = @('automation/Catzc.Base.Globs/configs/*.yml') } }
            $c.Get('unit').Matches('automation/Catzc.Base.Globs/configs/globs.yml') | Should -BeTrue
        }
    }
}
