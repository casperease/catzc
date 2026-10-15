<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Docs/tests/types/GlossaryEntry.Tests.ps1
    kind: test
---
#>

# Validates the compiled GlossaryEntry result type — one merged concept with its owning module, source path, and
# options. Fixture terms are neutral (widget/gadget,
# [ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
Describe 'GlossaryEntry' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:source = [Catzc.Base.Docs.GlossaryConfig]::new([ordered]@{
                concepts = [ordered]@{
                    'widget suite' = [ordered]@{
                        key         = 'widget_suite'
                        domain      = 'automation'
                        defined_by  = 'ADR-COG-GADGET#30'
                        short       = 'A named folder of widget files.'
                        realized_by = [ordered]@{ kind = 'prose-only' }
                    }
                }
            })
        $script:make = {
            param([string] $owner = 'Catzc.Widget', [string] $path = 'automation/Catzc.Widget/configs/glossary.yml')
            [Catzc.Base.Docs.GlossaryEntry]::new($script:source.concepts[0], $owner, $path, $script:source.options)
        }
    }

    It 'carries the concept, its owner, its repo-relative source path, and the source options' -Tag 'ADR-REPO-VOCAB#2' {
        $entry = & $script:make
        $entry.Concept.term | Should -Be 'widget suite'
        $entry.Owner | Should -Be 'Catzc.Widget'
        $entry.SourcePath | Should -Be 'automation/Catzc.Widget/configs/glossary.yml'
        $entry.Options.checks | Should -Be @('anchored', 'single', 'avoid', 'enforced', 'forms')
    }

    It 'rejects a source path that is not repo-relative' -Tag 'ADR-REPO-VOCAB#3' {
        foreach ($path in '/automation/glossary.yml', 'C:/repo/glossary.yml', 'automation\glossary.yml', '../glossary.yml', ' ') {
            { & $script:make -path $path } | Should -Throw '*must be repo-relative*' -Because "'$path' is not a repo-relative '/'-separated path"
        }
    }

    It 'requires an owner, a concept, and options' {
        { & $script:make -owner '' } | Should -Throw '*owning module*'
        { [Catzc.Base.Docs.GlossaryEntry]::new($null, 'Catzc.Widget', 'automation/glossary.yml', $script:source.options) } | Should -Throw '*concept*'
        { [Catzc.Base.Docs.GlossaryEntry]::new($script:source.concepts[0], 'Catzc.Widget', 'automation/glossary.yml', $null) } | Should -Throw '*options*'
    }
}
