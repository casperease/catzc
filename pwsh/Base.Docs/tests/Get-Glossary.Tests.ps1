<#
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-docs/tests/Get-Glossary.Tests.ps1.md"
  header: "generated"
---
#>

Describe 'Get-Glossary' -Tag 'L0', 'logic' {
    BeforeAll {
        $concept = {
            param([string] $key, [string] $rule)
            [ordered]@{
                key         = $key
                domain      = 'automation'
                defined_by  = $rule
                short       = "The $key."
                realized_by = [ordered]@{ kind = 'prose-only' }
            }
        }
        $widgets = [Catzc.Base.Docs.GlossaryConfig]::new([ordered]@{
                options  = [ordered]@{ checks = @('avoid') }
                concepts = [ordered]@{
                    'widget suite' = (& $concept 'widget_suite' 'ADR-COG-GADGET-SUITE')
                    'alpha widget' = (& $concept 'alpha_widget' 'ADR-COG-GADGET-RUN')
                }
            })
        $gadgets = [Catzc.Base.Docs.GlossaryConfig]::new([ordered]@{
                concepts = [ordered]@{ 'gadget run' = (& $concept 'gadget_run' 'ADR-COG-GADGET-STEP') }
            })
        $script:sources = @(
            [pscustomobject]@{ Owner = 'Catzc.Gadget'; Path = 'widgets/Catzc.Gadget/configs/glossary.yml'; Config = $gadgets; Tracked = $true }
            [pscustomobject]@{ Owner = 'Catzc.Widget'; Path = 'widgets/Catzc.Widget/configs/glossary.yml'; Config = $widgets; Tracked = $true }
        )
    }

    BeforeEach {
        InModuleScope Catzc.Base.Docs { $script:glossaryCache = $null }
        Mock Get-GlossarySources -ModuleName Catzc.Base.Docs { $script:sources }
    }

    AfterAll {
        # The cache is keyed by the real repository root, so a fixture glossary left in it would be served to a later caller in this worker.
        InModuleScope Catzc.Base.Docs { $script:glossaryCache = $null }
    }

    It 'merges every source''s concepts, each with its owner, source path, and that source''s options' -Tag 'ADR-REPO-VOCAB-GLOSSARYSOURCE' {
        $glossary = Get-Glossary
        $glossary.Count | Should -Be 3
        $widget = $glossary | Where-Object { $_.Concept.term -eq 'widget suite' }
        $widget | Should -BeOfType ([Catzc.Base.Docs.GlossaryEntry])
        $widget.Owner | Should -Be 'Catzc.Widget'
        $widget.SourcePath | Should -Be 'widgets/Catzc.Widget/configs/glossary.yml'
        $widget.Options.checks | Should -Be @('avoid')
        ($glossary | Where-Object { $_.Concept.term -eq 'gadget run' }).Options.checks | Should -Be @('anchored',
            'single', 'avoid', 'enforced', 'forms')
    }

    It 'sorts the merged concepts by term (ordinal), across sources' {
        (Get-Glossary).Concept.term | Should -Be @('alpha widget', 'gadget run', 'widget suite')
    }

    It 'returns an empty glossary when no module ships a source' {
        Mock Get-GlossarySources -ModuleName Catzc.Base.Docs { }
        $glossary = Get-Glossary
        , $glossary | Should -BeOfType ([Catzc.Base.Docs.GlossaryEntry[]])
        $glossary.Count | Should -Be 0
    }

    It 'caches the merged glossary per repository root for the session' {
        $first = Get-Glossary
        $second = Get-Glossary
        [object]::ReferenceEquals($first, $second) | Should -BeTrue
        Should -Invoke Get-GlossarySources -ModuleName Catzc.Base.Docs -Times 1 -Exactly

        Mock Get-RepositoryRoot -ModuleName Catzc.Base.Docs { 'TestDrive:/elsewhere' }
        [object]::ReferenceEquals($first, (Get-Glossary)) | Should -BeFalse
        Should -Invoke Get-GlossarySources -ModuleName Catzc.Base.Docs -Times 2 -Exactly
    }
}
