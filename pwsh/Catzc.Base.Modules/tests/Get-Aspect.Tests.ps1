<#
---
catzc:
  immutable:
    with_body_sha: "253280eee979"
  edges:
    code: pwsh/Catzc.Base.Modules/Get-Aspect.ps1
    cites:
      - ADR-AUTO-MODULE-EXISTSBYLAYOUT
      - ADR-DSGN-ASPECT
---
#>

# Rests on [ADR-DSGN-ASPECT](/docs/adr/design/module-aspects.md).
Describe 'Get-Aspect' -Tag 'L0', 'logic', 'ADR-AUTO-MODULE-EXISTSBYLAYOUT' {
    BeforeAll {
        $script:tracks = [Catzc.Base.Variants.VariantsConfig]::new([ordered]@{ tracks = [ordered]@{
                    widgets = [ordered]@{ places = @('widgetry'); type = 'modules'; languages = @('widget-script') }
                    gizmos  = [ordered]@{ places = @('gizmo'); type = 'gizmo-shelf' }
                    shelves = [ordered]@{ places = @('shelf'); type = 'shelf-works'; languages = @('widget-script') }
                }
            }).tracks
        $script:languages = [Catzc.Base.Languages.LanguagesConfig]::new([ordered]@{ languages = [ordered]@{
                    'widget-script' = [ordered]@{ extensions = @('.wdg'); no_formatter = 'fixture'; layout = @(
                            [ordered]@{ folder = '.'; role = 'public-widget'; extensions = @('.wdg') }
                            [ordered]@{ folder = 'inner'; role = 'private-widget' }
                        )
                    }
                }
            })
        Mock Get-Track -ModuleName Catzc.Base.Modules { $script:tracks }
        Mock Get-Config -ModuleName Catzc.Base.Modules -ParameterFilter { $Config -eq 'languages' } { $script:languages }
        Mock Get-AspectDeclaration -ModuleName Catzc.Base.Modules { , [Catzc.Base.Variants.VariantsConfig]::new([ordered]@{ tracks = [ordered]@{ widgets = [ordered]@{ places = @('widgetry'); type = 'modules' } } }).aspects }
    }

    It 'derives a code track''s convention from the layout: live closed to the layout''s live rows, tests the catch-all' {
        $aspects = @(Get-Aspect -Track widgets)
        $aspects[0] | Should -BeOfType [Catzc.Base.Variants.VariantAspect]
        $aspects.Name | Should -Be @('live', 'tests')
        $aspects[0].Patterns | Should -Be @('*.wdg', 'inner/**', 'assets/**')
        $aspects[-1].Patterns | Should -Be @('**')
    }

    It 'derives the convention from the layout for a track of any type whose primary language is laid out' {
        $aspects = @(Get-Aspect -Track shelves)
        $aspects.Name | Should -Be @('live', 'tests')
        $aspects[0].Patterns | Should -Be @('*.wdg', 'inner/**', 'assets/**')
    }

    It 'defaults infrastructure to live-as-catch-all (a deployment ships everything but tests/)' {
        $aspects = @(Get-Aspect -Track infrastructure)
        $aspects.Name | Should -Be @('tests', 'live')
        $aspects[-1].Patterns | Should -Be @('**')
    }

    It 'returns a configured convention in declared order, ahead of the built-in one' {
        Mock Get-AspectDeclaration -ModuleName Catzc.Base.Modules {
            , [Catzc.Base.Variants.VariantsConfig]::new([ordered]@{ tracks = [ordered]@{ widgets = [ordered]@{ places = @('widgetry'); type = 'modules' } }; aspects = [ordered]@{ gizmos = @([ordered]@{ live = @('src/**') }, [ordered]@{ tests = @('**') }) } }).aspects
        }
        $aspects = @(Get-Aspect -Track gizmos)
        $aspects.Name | Should -Be @('live', 'tests')
        $aspects[0].Patterns | Should -Be @('src/**')
    }

    It 'falls back to the code convention for a track with no convention of its own' {
        $aspects = @(Get-Aspect -Track nonesuch)
        $aspects.Name | Should -Be @('live', 'tests')
        $aspects[0].Patterns | Should -Be @('*.wdg', 'inner/**', 'assets/**')
    }
}

Describe 'Get-Aspect on the repository' -Tag 'L1', 'integrity', 'ADR-AUTO-MODULE-EXISTSBYLAYOUT' {
    It 'gives the code track the five live folders the aspects were written with' {
        $code = Get-Track -Path (Get-CatzcModulesFolder)
        (Get-Aspect -Track $code.name)[0].Patterns | Should -Be @('*.ps1', 'private/**', 'types/**', 'configs/**', '*.py', '*.go', '*.sh', 'assets/**')
    }
}
