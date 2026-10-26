<#
---
catzc:
  docs: "../../../../docs/references/pwsh/catzc-base-docs/tests/types/GlossaryEntry.Tests.ps1.md"
  header: "generated"
---
#>

Describe 'GlossaryEntry' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:source = [Catzc.Base.Docs.GlossaryConfig]::new([ordered]@{
                concepts = [ordered]@{
                    'widget suite' = [ordered]@{
                        key         = 'widget_suite'
                        domain      = 'automation'
                        defined_by  = 'ADR-COG-GADGET-SUITE'
                        short       = 'A named folder of widget files.'
                        realized_by = [ordered]@{ kind = 'prose-only' }
                    }
                }
            })
        $script:make = {
            param([string] $owner = 'Catzc.Widget', [string] $path = 'widgets/Catzc.Widget/configs/glossary.yml')
            [Catzc.Base.Docs.GlossaryEntry]::new($script:source.concepts[0], $owner, $path, $script:source.options)
        }
    }

    It 'carries the concept, its owner, its repo-relative source path, and the source options' -Tag 'ADR-REPO-VOCAB-GLOSSARYSOURCE' {
        $entry = & $script:make
        $entry.Concept.term | Should -Be 'widget suite'
        $entry.Owner | Should -Be 'Catzc.Widget'
        $entry.SourcePath | Should -Be 'widgets/Catzc.Widget/configs/glossary.yml'
        $entry.Options.checks | Should -Be @('anchored', 'single', 'avoid', 'enforced', 'forms')
    }

    It 'rejects a source path that is not repo-relative' -Tag 'ADR-REPO-VOCAB-SOURCESINREPOSITORY' {
        foreach ($path in '/widgets/glossary.yml', 'C:/repo/glossary.yml', 'widgets\glossary.yml', '../glossary.yml',
            ' ') {
            { & $script:make -path $path } |
                Should -Throw '*must be repo-relative*' -Because "'$path' is not a repo-relative '/'-separated path"
        }
    }

    It 'requires an owner, a concept, and options' {
        { & $script:make -owner '' } | Should -Throw '*owning module*'
        { [Catzc.Base.Docs.GlossaryEntry]::new($null, 'Catzc.Widget', 'widgets/glossary.yml',
                $script:source.options) } | Should -Throw '*concept*'
        { [Catzc.Base.Docs.GlossaryEntry]::new($script:source.concepts[0], 'Catzc.Widget', 'widgets/glossary.yml',
                $null) } | Should -Throw '*options*'
    }
}
