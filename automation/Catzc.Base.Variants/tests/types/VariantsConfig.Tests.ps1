<#
---
catzc:
  immutable:
    path: automation/Catzc.Base.Variants/tests/types/VariantsConfig.Tests.ps1
    folder: tests/types
    name: variants-config-tests
    filetype: ps1
    kind: test
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.Variants
    moduletype: pwsh-folder
    catzc_bundle: azure
---
#>

Describe 'VariantsConfig' -Tag 'L0' {
    BeforeAll {
        $script:make = { param([System.Collections.IDictionary] $raw) [Catzc.Base.Variants.VariantsConfig]::new($raw) }
    }

    Context 'integrity (shipped variants.yml)' -Tag 'integrity' {
        It 'passes for the shipped variants.yml' {
            Get-Config -Config variants | Should -BeOfType [Catzc.Base.Variants.VariantsConfig]
        }
    }

    Context 'logic (fixture configs)' -Tag 'logic' {
        It 'passes for a minimal valid config' {
            $config = & $script:make ([ordered]@{ ado_naming = 'standard'; have_customers = $false })
            $config.ado_naming | Should -Be 'standard'
            $config.have_customers | Should -BeFalse
            $config.Contains('have_customers') | Should -BeTrue
        }

        It 'passes for an empty config (all keys default)' {
            $config = & $script:make ([ordered]@{})
            $config.Keys.Count | Should -Be 0
            $config.Contains('ado_naming') | Should -BeFalse
        }

        It 'accepts have_customers as the string all' {
            (& $script:make ([ordered]@{ have_customers = 'all' })).have_customers | Should -Be 'all'
        }

        It 'accepts have_customers as a list of names' {
            (& $script:make ([ordered]@{ have_customers = @('acme', 'globex') })).have_customers | Should -Be @('acme', 'globex')
        }

        It 'accepts have_customers as a boolean true' {
            (& $script:make ([ordered]@{ have_customers = $true })).have_customers | Should -BeTrue
        }

        It 'throws on an unknown key' {
            { & $script:make ([ordered]@{ ado_naming = 'standard'; bogus = 1 }) } | Should -Throw '*unknown key*bogus*'
        }

        It 'throws on an invalid ado_naming' {
            { & $script:make ([ordered]@{ ado_naming = 'sideways' }) } | Should -Throw '*invalid ado_naming*'
        }

        It 'accepts both git_workspace modes and throws on any other value' {
            foreach ($mode in 'main-direct', 'main-via-pr') {
                (& $script:make ([ordered]@{ git_workspace = $mode })).git_workspace | Should -Be $mode
            }
            { & $script:make ([ordered]@{ git_workspace = 'anarchy' }) } | Should -Throw '*invalid git_workspace*'
        }

        It 'throws when have_customers is a non-all string' {
            { & $script:make ([ordered]@{ have_customers = 'some' }) } | Should -Throw "*a string must be 'all'*"
        }

        It 'throws when a have_customers list holds an invalid name' {
            { & $script:make ([ordered]@{ have_customers = @('acme', 'Bad-Name') }) } | Should -Throw '*invalid have_customers customer name*'
        }

        It 'throws when a have_customers list has a duplicate name' {
            { & $script:make ([ordered]@{ have_customers = @('acme', 'acme') }) } | Should -Throw '*duplicate have_customers customer name*'
        }

        It 'accepts per-track conventions (automation live-closed, infra live-catch-all)' {
            $config = & $script:make ([ordered]@{ aspects = [ordered]@{
                        automation     = @([ordered]@{ live = @('*.ps1', 'private/**') }, [ordered]@{ tests = @('**') })
                        infrastructure = @([ordered]@{ tests = @('**/tests/**') }, [ordered]@{ live = @('**') })
                    }
                })
            $config.aspects['automation'].Name | Should -Be @('live', 'tests')
            $config.aspects['automation'][0].Patterns | Should -Be @('*.ps1', 'private/**')
            $config.aspects['infrastructure'][-1].Patterns | Should -Be @('**')
        }

        It 'throws when a track is not a map of ordered aspect lists' {
            $config = [ordered]@{ aspects = @([ordered]@{ live = @('**') }) }   # a bare list, not a track map
            { & $script:make $config } | Should -Throw '*must be a map of track*'
        }

        It "throws when a track's last aspect is not the ** catch-all" {
            $config = [ordered]@{ aspects = [ordered]@{ automation = @([ordered]@{ live = @('*.ps1') }, [ordered]@{ tests = @('tests/**') }) } }
            { & $script:make $config } | Should -Throw "*last aspect*must be the '**' catch-all*"
        }

        It 'throws when a non-last aspect uses the bare ** catch-all' {
            $config = [ordered]@{ aspects = [ordered]@{ automation = @([ordered]@{ live = @('**') }, [ordered]@{ tests = @('**') }) } }
            { & $script:make $config } | Should -Throw '*not last*'
        }

        It 'throws on a duplicate or non-kebab aspect name' {
            $config = [ordered]@{ aspects = [ordered]@{ automation = @([ordered]@{ Live = @('*.ps1') }, [ordered]@{ tests = @('src/**') }, [ordered]@{ tests = @('**') }) } }
            $err = { & $script:make $config } | Should -Throw -PassThru
            $err.Exception.Message | Should -BeLike "*invalid aspect name 'Live'*"
            $err.Exception.Message | Should -BeLike "*duplicate aspect 'tests'*"
        }

        It 'accepts tracks in declared order, with a vendor and languages optional' {
            $config = & $script:make ([ordered]@{ tracks = [ordered]@{
                        widget    = [ordered]@{ places = @('widget'); type = 'widget-works'; languages = @('widget-lang', 'gadget-lang') }
                        '.gadget' = [ordered]@{ places = @('.gadget', '.gadget/deep'); type = 'gadget-shelf'; vendor = 'gizmo' }
                    }
                })
            $config.tracks.name | Should -Be @('widget', '.gadget')
            $config.tracks[0] | Should -BeOfType [Catzc.Base.Variants.VariantTrack]
            $config.tracks[0].places | Should -Be @('widget')
            $config.tracks[0].type | Should -Be 'widget-works'
            $config.tracks[0].vendor | Should -BeNullOrEmpty
            $config.tracks[0].languages | Should -Be @('widget-lang', 'gadget-lang')
            $config.tracks[1].places | Should -Be @('.gadget', '.gadget/deep')
            $config.tracks[1].vendor | Should -Be 'gizmo'
            $config.tracks[1].languages.Count | Should -Be 0
        }

        It 'gives the length of the longest place that contains a path, and -1 when none does' -ForEach @(
            @{ Path = 'widget/a/b.txt'; Length = 6 }
            @{ Path = 'widget'; Length = 6 }
            @{ Path = 'widget/deep/b.txt'; Length = 11 }
            @{ Path = 'widgets/a.txt'; Length = -1 }
            @{ Path = 'gadget/a.txt'; Length = -1 }
        ) {
            $config = & $script:make ([ordered]@{ tracks = [ordered]@{ widget = [ordered]@{ places = @('widget', 'widget/deep'); type = 'widget-works' } } })
            $config.tracks[0].PlaceLengthOf($Path) | Should -Be $Length
        }

        It 'throws on a missing or malformed type' {
            { & $script:make ([ordered]@{ tracks = [ordered]@{ widget = [ordered]@{ places = @('widget') } } }) } | Should -Throw "*invalid type ''*"
            { & $script:make ([ordered]@{ tracks = [ordered]@{ widget = [ordered]@{ places = @('widget'); type = 'Core' } } }) } | Should -Throw "*invalid type 'Core'*"
        }

        It 'throws on a malformed vendor' {
            { & $script:make ([ordered]@{ tracks = [ordered]@{ widget = [ordered]@{ places = @('widget'); type = 'widget-works'; vendor = 'Gizmo' } } }) } |
                Should -Throw "*invalid vendor 'Gizmo'*"
        }

        It 'throws on a place two tracks share' {
            $config = [ordered]@{ tracks = [ordered]@{
                    widget = [ordered]@{ places = @('widget'); type = 'widget-works' }
                    gadget = [ordered]@{ places = @('widget'); type = 'gadget-shelf' }
                }
            }
            { & $script:make $config } | Should -Throw "*place 'widget' is already a place of track 'widget'*"
        }

        It 'throws on an empty or missing places list' {
            { & $script:make ([ordered]@{ tracks = [ordered]@{ widget = [ordered]@{ places = @(); type = 'widget-works' } } }) } |
                Should -Throw '*needs at least one place*'
            { & $script:make ([ordered]@{ tracks = [ordered]@{ widget = [ordered]@{ type = 'widget-works' } } }) } |
                Should -Throw '*needs at least one place*'
        }

        It 'throws on a place that is not a clean relative path' {
            foreach ($place in 'widget/', '/widget', 'widget//gadget', '..', 'widget/../gadget') {
                { & $script:make ([ordered]@{ tracks = [ordered]@{ widget = [ordered]@{ places = @($place); type = 'widget-works' } } }) } |
                    Should -Throw '*invalid place*'
            }
        }

        It 'throws on the out place (gitignored output, never a track)' {
            { & $script:make ([ordered]@{ tracks = [ordered]@{ widget = [ordered]@{ places = @('out/deep'); type = 'widget-works' } } }) } |
                Should -Throw "*place 'out/deep' is gitignored output*"
        }

        It 'throws on an unknown track key, a bad language name, and a duplicate language' {
            $config = [ordered]@{ tracks = [ordered]@{
                    widget = [ordered]@{ places = @('widget'); type = 'widget-works'; languages = @('Gadget', 'widget-lang', 'widget-lang'); colour = 'blue' }
                }
            }
            $err = { & $script:make $config } | Should -Throw -PassThru
            $err.Exception.Message | Should -BeLike "*unknown key 'colour'*"
            $err.Exception.Message | Should -BeLike "*invalid language name 'Gadget'*"
            $err.Exception.Message | Should -BeLike "*duplicate language 'widget-lang'*"
        }

        It 'refuses the removed root and class keys' {
            $err = { & $script:make ([ordered]@{ tracks = [ordered]@{ widget = [ordered]@{ places = @('widget'); type = 'widget-works'; root = 'widget'; class = 'core' } } }) } |
                Should -Throw -PassThru
            $err.Exception.Message | Should -BeLike "*unknown key 'root'*"
            $err.Exception.Message | Should -BeLike "*unknown key 'class'*"
        }

        It 'reads a track''s execution engines and a module''s override, and leaves both empty when unnamed' -Tag 'ADR-AUTO-MODULE#4' {
            $first = [Catzc.Base.Engines.ExecutionEngines]::Names[0]
            $second = [Catzc.Base.Engines.ExecutionEngines]::Names[1]
            $config = & $script:make ([ordered]@{ tracks = [ordered]@{
                        widget = [ordered]@{ places = @('widget'); type = 'widget-works'; execution_engines = @($first); module_execution_engines = [ordered]@{ Widget_Gadget = @($first, $second) } }
                        gadget = [ordered]@{ places = @('gadget'); type = 'widget-works' }
                    } })
            $config.tracks[0].execution_engines | Should -Be @($first)
            $config.tracks[0].EnginesOf('Widget_Gadget') | Should -Be @($first, $second)
            $config.tracks[0].EnginesOf('Widget_Other') | Should -Be @($first)
            @($config.tracks[1].execution_engines) | Should -HaveCount 0
            @($config.tracks[1].EnginesOf('Widget_Gadget')) | Should -HaveCount 0
            @($config.tracks[1].module_execution_engines.Keys) | Should -HaveCount 0
        }

        It 'throws on an engine outside the closed set, a duplicate engine, and an override that is empty, repeats the track, or is not a map' -Tag 'ADR-AUTO-MODULE#4' {
            $first = [Catzc.Base.Engines.ExecutionEngines]::Names[0]
            $second = [Catzc.Base.Engines.ExecutionEngines]::Names[1]
            $err = { & $script:make ([ordered]@{ tracks = [ordered]@{
                            widget = [ordered]@{ places = @('widget'); type = 'widget-works'; execution_engines = @($first, $first, 'fish')
                                module_execution_engines = [ordered]@{ A = @(); B = @($first, $first) } }
                        } }) } | Should -Throw -PassThru
            $err.Exception.Message | Should -BeLike "*unknown execution engine 'fish'*"
            $err.Exception.Message | Should -BeLike "*duplicate execution engine '$first'*"
            $err.Exception.Message | Should -Match ([regex]::Escape("module_execution_engines['A'] must name at least one engine"))
            { & $script:make ([ordered]@{ tracks = [ordered]@{
                            widget = [ordered]@{ places = @('widget'); type = 'widget-works'; execution_engines = @($first, $second); module_execution_engines = [ordered]@{ A = @($first, $second) } }
                        } }) } | Should -Throw "*repeats the track's engines*"
            { & $script:make ([ordered]@{ tracks = [ordered]@{
                            widget = [ordered]@{ places = @('widget'); type = 'widget-works'; module_execution_engines = @('A') }
                        } }) } | Should -Throw '*module_execution_engines must be a map*'
        }

        It 'throws when tracks is empty, not a map, or holds a non-map entry' {
            { & $script:make ([ordered]@{ tracks = [ordered]@{} }) } | Should -Throw '*at least one track*'
            { & $script:make ([ordered]@{ tracks = @('widget') }) } | Should -Throw '*invalid tracks*'
            { & $script:make ([ordered]@{ tracks = [ordered]@{ widget = 'widget' } }) } | Should -Throw '*must be a mapping { places, type, vendor, languages }*'
        }

        It 'reports every violation in one throw' {
            $err = { & $script:make ([ordered]@{ ado_naming = 'sideways'; git_workspace = 'anarchy'; have_customers = 'some'; bogus = 1 }) } |
                Should -Throw -PassThru
            foreach ($expected in '*unknown key*bogus*', '*invalid ado_naming*', '*invalid git_workspace*', "*a string must be 'all'*") {
                $err.Exception.Message | Should -BeLike $expected
            }
        }
    }
}
