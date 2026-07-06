# The globs.yml registry gate: strict shape (unknown keys rejected), every entry a valid GlobSet with a
# declared layer (ADR-GLOBS:7), compose resolving acyclically to declared sets (ADR-GLOBS:8), and the
# self-exclusion rule — no globset may have a sha-marker file or the config itself as an effective member
# (ADR-GLOBS:6).
Describe 'GlobsConfig' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:make = {
            param([hashtable] $globsets)
            [Catzc.Base.Globs.GlobsConfig]::new(@{ globsets = $globsets })
        }
    }

    Context 'a valid registry' {
        It 'constructs and exposes the sets with lookup' {
            # Neutral fixture globset names (widget/gadget), not the real track/deployable-unit names (ADR-TEST:3).
            $c = & $script:make @{
                'widget' = @{ description = 'the widget track'; layer = 'track'; include = @('src/**', 'main.ps1') }
                'gadget' = @{ description = 'the gadget unit'; layer = 'deployable-unit'; include = @('lib/**'); exclude = @('**/*.md') }
            }
            $c.globsets.Count | Should -Be 2
            $c.Names | Should -Contain 'widget'
            $c.Contains('gadget') | Should -BeTrue
            $c.Contains('nope') | Should -BeFalse
            $c.Get('gadget').MarkerPath | Should -Be '.sha-markers/gadget.yml'
            $c.Get('gadget').Layer | Should -Be 'deployable-unit'
            $c.Get('gadget').Matches('lib/x/readme.md') | Should -BeFalse
        }

        It 'throws a named error on an unknown set lookup' {
            $c = & $script:make @{ unit = @{ description = 'd'; layer = 'scope'; include = @('src/**') } }
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

    Context 'composition (ADR-GLOBS:8)' {
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

        It 'flattens the composed surface into the marker scan program, own rules last (ADR-GLOBS:8, ADR-GLOBS:9)' {
            $c = & $script:make @{
                'base' = @{ description = 'd'; layer = 'deployable-unit'; include = @('shared/**'); exclude = @('shared/config/**') }
                'unit' = @{ description = 'd'; layer = 'deployable-unit'; compose = @('base'); include = @('mine/**'); pipeline = 'cd-unit' }
            }
            $expectedLines = @(
                'name: unit'
                'description: d'
                'layer: deployable-unit'
                'pipeline: cd-unit'
                'compose:'
                '- base'
                'scan:'
                "- '+ shared/**'"      # base rules first...
                "- '- shared/config/**'"
                "- '+ mine/**'"        # ...then unit's own rule last
            )
            $c.Get('unit').Representation | Should -Be (($expectedLines -join "`n") + "`n")
            # the base set composes nothing, so its program is just its own rules
            $c.Get('base').Representation | Should -Match "scan:`n- '\+ shared/\*\*'`n- '- shared/config/\*\*'`n"
        }

        It 'flattens transitively, each rule appearing once — dedupe keeps the last occurrence (ADR-GLOBS:8)' {
            $c = & $script:make @{
                'leaf' = @{ description = 'd'; layer = 'deployable-unit'; include = @('leaf/**') }
                'mid'  = @{ description = 'd'; layer = 'deployable-unit'; compose = @('leaf'); include = @('mid/**') }
                'top'  = @{ description = 'd'; layer = 'deployable-unit'; compose = @('mid', 'leaf'); include = @('top/**') }
            }
            # top composes [mid, leaf]; mid already pulls leaf. Raw: +leaf,+mid,+leaf,+top -> dedupe-last: +mid,+leaf,+top
            $rep = $c.Get('top').Representation
            $rep | Should -Match "scan:`n- '\+ mid/\*\*'`n- '\+ leaf/\*\*'`n- '\+ top/\*\*'`n"
        }

        It 'rejects a compose reference to an unknown set' {
            { & $script:make @{ unit = @{ description = 'd'; layer = 'deployable-unit'; compose = @('nope') } } } |
                Should -Throw '*unknown set*ADR-GLOBS:8*'
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
            @{ why = 'an unknown top-level key'; block = { [Catzc.Base.Globs.GlobsConfig]::new(@{ globsets = @{ u = @{ description = 'd'; layer = 'scope'; include = @('a/**') } }; extra = 1 }) } }
            @{ why = 'an unknown per-set key'; block = { [Catzc.Base.Globs.GlobsConfig]::new(@{ globsets = @{ u = @{ description = 'd'; layer = 'scope'; include = @('a/**'); owner = 'x' } } }) } }
            @{ why = 'a non-mapping set entry'; block = { [Catzc.Base.Globs.GlobsConfig]::new(@{ globsets = @{ u = 'not-a-map' } }) } }
            @{ why = 'a set with neither include nor compose'; block = { [Catzc.Base.Globs.GlobsConfig]::new(@{ globsets = @{ u = @{ description = 'd'; layer = 'scope' } } }) } }
            @{ why = 'a set with no description'; block = { [Catzc.Base.Globs.GlobsConfig]::new(@{ globsets = @{ u = @{ layer = 'scope'; include = @('a/**') } } }) } }
            @{ why = 'a set with no layer'; block = { [Catzc.Base.Globs.GlobsConfig]::new(@{ globsets = @{ u = @{ description = 'd'; include = @('a/**') } } }) } }
            @{ why = "the derived-only 'module' layer"; block = { [Catzc.Base.Globs.GlobsConfig]::new(@{ globsets = @{ u = @{ description = 'd'; layer = 'module'; include = @('a/**') } } }) } }
            @{ why = 'a non-kebab set name'; block = { [Catzc.Base.Globs.GlobsConfig]::new(@{ globsets = @{ MyUnit = @{ description = 'd'; layer = 'scope'; include = @('a/**') } } }) } }
            @{ why = 'a verify without modules'; block = { [Catzc.Base.Globs.GlobsConfig]::new(@{ globsets = @{ u = @{ description = 'd'; layer = 'scope'; include = @('a/**'); verify = @{ level = 1 } } } }) } }
            @{ why = 'a verify with an out-of-range level'; block = { [Catzc.Base.Globs.GlobsConfig]::new(@{ globsets = @{ u = @{ description = 'd'; layer = 'scope'; include = @('a/**'); verify = @{ modules = @('M'); level = 9 } } } }) } }
            @{ why = 'a verify with an unknown key'; block = { [Catzc.Base.Globs.GlobsConfig]::new(@{ globsets = @{ u = @{ description = 'd'; layer = 'scope'; include = @('a/**'); verify = @{ modules = @('M'); level = 1; extra = 1 } } } }) } }
        ) {
            $block | Should -Throw
        }

        It 'collects several errors into one failure' {
            {
                & $script:make @{
                    'BadName' = @{ description = 'd'; layer = 'scope'; include = @('a/**') }
                    'no-desc' = @{ layer = 'scope'; include = @('a/**') }
                }
            } | Should -Throw '*validation failed*'
        }
    }

    Context 'self-exclusion (ADR-GLOBS:6)' {
        It 'rejects a set matching its own marker file' {
            { & $script:make @{ unit = @{ description = 'd'; layer = 'scope'; include = @('.sha-markers/unit.yml') } } } |
                Should -Throw '*ADR-GLOBS:6*'
        }

        It "rejects a set matching another set's marker file" {
            {
                & $script:make @{
                    'a-unit' = @{ description = 'd'; layer = 'scope'; include = @('src/**') }
                    'b-unit' = @{ description = 'd'; layer = 'scope'; include = @('.sha-markers/a-unit.yml') }
                }
            } | Should -Throw '*ADR-GLOBS:6*'
        }

        It 'rejects a catch-all include via the canary probe' {
            { & $script:make @{ unit = @{ description = 'd'; layer = 'scope'; include = @('**') } } } |
                Should -Throw '*ADR-GLOBS:6*'
        }

        It 'rejects a marker file inherited through compose' {
            # 'leaky' matches the COMPOSING set's marker, so only the effective (composed) membership of
            # 'unit' trips the probe — proving the self-exclusion check sees through compose.
            {
                & $script:make @{
                    'leaky' = @{ description = 'd'; layer = 'scope'; include = @('.sha-markers/unit.yml') }
                    'unit'  = @{ description = 'd'; layer = 'deployable-unit'; compose = @('leaky') }
                }
            } | Should -Throw '*ADR-GLOBS:6*'
        }

        It 'accepts a set including the config itself — an ordinary tracked file' {
            $c = & $script:make @{ unit = @{ description = 'd'; layer = 'scope'; include = @('automation/Catzc.Base.Globs/configs/*.yml') } }
            $c.Get('unit').Matches('automation/Catzc.Base.Globs/configs/globs.yml') | Should -BeTrue
        }

        It 'accepts a catch-all whose exclude carves out .sha-markers/' {
            $c = & $script:make @{
                everything = @{
                    description = 'the whole tree'
                    layer       = 'scope'
                    include     = @('**')
                    exclude     = @('.sha-markers/**')
                }
            }
            $c.Get('everything').Matches('docs/index.md') | Should -BeTrue
            $c.Get('everything').Matches('automation/Catzc.Base.Globs/configs/globs.yml') | Should -BeTrue
            $c.Get('everything').Matches('.sha-markers/everything.yml') | Should -BeFalse
        }
    }
}
