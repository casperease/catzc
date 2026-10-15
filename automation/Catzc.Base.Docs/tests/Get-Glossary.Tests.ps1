# Get-Glossary merges the glossary sources into GlossaryEntry records. Discovery is mocked at Get-GlossarySources
# (its own tests cover the config seam and git), and the sources are built from the real GlossaryConfig type.
# Get-Glossary caches per repository root, so every test resets the cache entry
# ([ADR-PWSH-PESTER#3](/docs/adr/pwsh/pester-testing.md#rule-adr-pwsh-pester3)). Fixture terms
# are
# neutral (widget/gadget, [ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
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
                    'widget suite' = (& $concept 'widget_suite' 'ADR-COG-GADGET#30')
                    'alpha widget' = (& $concept 'alpha_widget' 'ADR-COG-GADGET#31')
                }
            })
        $gadgets = [Catzc.Base.Docs.GlossaryConfig]::new([ordered]@{
                concepts = [ordered]@{ 'gadget run' = (& $concept 'gadget_run' 'ADR-COG-GADGET#32') }
            })
        $script:sources = @(
            [pscustomobject]@{ Owner = 'Catzc.Gadget'; Path = 'automation/Catzc.Gadget/configs/glossary.yml'; Config = $gadgets; Tracked = $true }
            [pscustomobject]@{ Owner = 'Catzc.Widget'; Path = 'automation/Catzc.Widget/configs/glossary.yml'; Config = $widgets; Tracked = $true }
        )
    }

    BeforeEach {
        InModuleScope Catzc.Base.Docs { $script:glossaryCache = $null }
        Mock Get-GlossarySources -ModuleName Catzc.Base.Docs { $script:sources }
    }

    AfterAll {
        # The cache is keyed by the REAL repository root, so a fixture glossary left in it would be served to any later
        # caller in this worker — e.g. the real-tree glossary check.
        InModuleScope Catzc.Base.Docs { $script:glossaryCache = $null }
    }

    It 'merges every source''s concepts, each with its owner, source path, and that source''s options' -Tag 'ADR-REPO-VOCAB#2' {
        $glossary = Get-Glossary
        $glossary.Count | Should -Be 3
        $widget = $glossary | Where-Object { $_.Concept.term -eq 'widget suite' }
        $widget | Should -BeOfType ([Catzc.Base.Docs.GlossaryEntry])
        $widget.Owner | Should -Be 'Catzc.Widget'
        $widget.SourcePath | Should -Be 'automation/Catzc.Widget/configs/glossary.yml'
        $widget.Options.checks | Should -Be @('avoid')
        ($glossary | Where-Object { $_.Concept.term -eq 'gadget run' }).Options.checks | Should -Be @('anchored', 'single', 'avoid', 'enforced', 'forms')
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
