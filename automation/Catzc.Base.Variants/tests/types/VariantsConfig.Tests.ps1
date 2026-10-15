<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Variants/tests/types/VariantsConfig.Tests.ps1
    kind: test
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

        It 'accepts tracks in declared order, with languages defaulting to none' {
            $config = & $script:make ([ordered]@{ tracks = [ordered]@{
                        widget    = [ordered]@{ root = 'widget'; class = 'core'; languages = @('widget-lang', 'gadget-lang') }
                        '.gadget' = [ordered]@{ root = '.gadget'; class = 'external-port' }
                    }
                })
            $config.tracks.name | Should -Be @('widget', '.gadget')
            $config.tracks[0] | Should -BeOfType [Catzc.Base.Variants.VariantTrack]
            $config.tracks[0].root | Should -Be 'widget'
            $config.tracks[0].class | Should -Be 'core'
            $config.tracks[0].languages | Should -Be @('widget-lang', 'gadget-lang')
            $config.tracks[1].languages.Count | Should -Be 0
        }

        It 'accepts every class of the closed set' {
            foreach ($class in [Catzc.Base.Variants.VariantTrack]::Classes) {
                (& $script:make ([ordered]@{ tracks = [ordered]@{ widget = [ordered]@{ root = 'widget'; class = $class } } })).tracks[0].class |
                    Should -Be $class
            }
        }

        It 'throws on a class outside the closed set' {
            { & $script:make ([ordered]@{ tracks = [ordered]@{ widget = [ordered]@{ root = 'widget'; class = 'gizmo' } } }) } |
                Should -Throw "*invalid class 'gizmo'*"
        }

        It 'throws on a missing class' {
            { & $script:make ([ordered]@{ tracks = [ordered]@{ widget = [ordered]@{ root = 'widget' } } }) } | Should -Throw "*invalid class ''*"
        }

        It 'throws on a root two tracks share' {
            $config = [ordered]@{ tracks = [ordered]@{
                    widget = [ordered]@{ root = 'widget'; class = 'core' }
                    gadget = [ordered]@{ root = 'widget'; class = 'adapter' }
                }
            }
            { & $script:make $config } | Should -Throw "*root 'widget' is already the root of track 'widget'*"
        }

        It 'throws on an empty or missing root' {
            { & $script:make ([ordered]@{ tracks = [ordered]@{ widget = [ordered]@{ root = ''; class = 'core' } } }) } |
                Should -Throw '*needs a non-empty root folder*'
            { & $script:make ([ordered]@{ tracks = [ordered]@{ widget = [ordered]@{ class = 'core' } } }) } |
                Should -Throw '*needs a non-empty root folder*'
        }

        It 'throws on a root that is not one folder segment' {
            foreach ($root in 'widget/gadget', '..') {
                { & $script:make ([ordered]@{ tracks = [ordered]@{ widget = [ordered]@{ root = $root; class = 'core' } } }) } |
                    Should -Throw '*invalid root*'
            }
        }

        It 'throws on the out root (gitignored output, never a track)' {
            { & $script:make ([ordered]@{ tracks = [ordered]@{ widget = [ordered]@{ root = 'out'; class = 'core' } } }) } |
                Should -Throw "*root 'out' is gitignored output*"
        }

        It 'throws on an unknown track key, a bad language name, and a duplicate language' {
            $config = [ordered]@{ tracks = [ordered]@{
                    widget = [ordered]@{ root = 'widget'; class = 'core'; languages = @('Gadget', 'widget-lang', 'widget-lang'); colour = 'blue' }
                }
            }
            $err = { & $script:make $config } | Should -Throw -PassThru
            $err.Exception.Message | Should -BeLike "*unknown key 'colour'*"
            $err.Exception.Message | Should -BeLike "*invalid language name 'Gadget'*"
            $err.Exception.Message | Should -BeLike "*duplicate language 'widget-lang'*"
        }

        It 'throws when tracks is empty, not a map, or holds a non-map entry' {
            { & $script:make ([ordered]@{ tracks = [ordered]@{} }) } | Should -Throw '*at least one track*'
            { & $script:make ([ordered]@{ tracks = @('widget') }) } | Should -Throw '*invalid tracks*'
            { & $script:make ([ordered]@{ tracks = [ordered]@{ widget = 'widget' } }) } | Should -Throw '*must be a mapping { root, class, languages }*'
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
