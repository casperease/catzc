<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Docs/tests/types/GlossaryConfig.Tests.ps1
    kind: pester-test
    relatives:
      page: docs/references/automation/catzc-base-docs/tests/types/GlossaryConfig.Tests.ps1.md
      source: automation/Catzc.Base.Docs/types/GlossaryConfig.cs
    adrs:
      - ADR-AUTO-TEST#3
      - ADR-REPO-VOCAB#1
      - ADR-REPO-VOCAB#2
      - ADR-REPO-VOCAB#3
      - ADR-REPO-VOCAB#4
      - ADR-REPO-VOCAB#5
      - ADR-REPO-VOCAB#6
      - ADR-REPO-VOCAB#8
---
#>

Describe 'GlossaryConfig' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:make = {
            param([System.Collections.IDictionary] $raw) [Catzc.Base.Docs.GlossaryConfig]::new($raw)
        }
        # A well-formed concept body; each test copies it and breaks one thing.
        $script:concept = {
            [ordered]@{
                key         = 'widget_suite'
                domain      = 'automation'
                defined_by  = 'ADR-COG-GADGET#30'
                short       = 'A named folder of widget files.'
                realized_by = [ordered]@{ kind = 'folder'; pattern = 'automation/*/tests/suites/<name>/' }
            }
        }
        $script:single = {
            param([System.Collections.IDictionary] $body, [string] $term = 'widget suite')
            & $script:make ([ordered]@{ concepts = [ordered]@{ $term = $body } })
        }
    }

    It 'constructs a minimal source and defaults every option' -Tag 'ADR-REPO-VOCAB#2' {
        $c = & $script:single (& $script:concept)
        $c.concepts.Count | Should -Be 1
        $c.concepts[0].term | Should -Be 'widget suite'
        $c.concepts[0].key | Should -Be 'widget_suite'
        $c.concepts[0].short | Should -Be 'A named folder of widget files.'
        $c.concepts[0].realized_by.kind | Should -Be 'folder'
        $c.concepts[0].relations.Count | Should -Be 0
        $c.concepts[0].contrasts.Count | Should -Be 0
        $c.concepts[0].avoid.Count | Should -Be 0
        $c.options.checks | Should -Be @('anchored', 'single', 'avoid', 'enforced', 'forms')
        $c.options.surfaces | Should -Be @('markdown', 'comments', 'help', 'messages')
        $c.options.scope | Should -Be @('**')
        $c.options.exclude | Should -Be @('docs/adr/research/**', 'docs/references/dora/**', 'out/**', '.unordered/**', 'automation/.vendor/**')
    }

    It 'keeps concepts in source order' {
        $second = & $script:concept
        $second.key = 'gadget_run'
        $c = & $script:make ([ordered]@{ concepts = [ordered]@{ 'widget suite' = (& $script:concept); 'gadget run' = $second } })
        $c.concepts.term | Should -Be @('widget suite', 'gadget run')
    }

    It 'overrides only the options a source sets, and always keeps the default excludes first' -Tag 'ADR-REPO-VOCAB#2' {
        $c = & $script:make ([ordered]@{
                options  = [ordered]@{ checks = @('avoid'); scope = @('docs/**'); exclude = @('docs/widget/**', 'out/**') }
                concepts = [ordered]@{ 'widget suite' = (& $script:concept) }
            })
        $c.options.checks | Should -Be @('avoid')
        $c.options.scope | Should -Be @('docs/**')
        $c.options.surfaces | Should -Be @('markdown', 'comments', 'help', 'messages')
        $c.options.exclude | Should -Be @('docs/adr/research/**', 'docs/references/dora/**', 'out/**', '.unordered/**', 'automation/.vendor/**', 'docs/widget/**')
    }

    It 'accepts an explicit empty checks list (opted in, structural check only)' -Tag 'ADR-REPO-VOCAB#2' {
        $c = & $script:make ([ordered]@{ options = @{ checks = @() }; concepts = [ordered]@{ 'widget suite' = (& $script:concept) } })
        $c.options.checks.Count | Should -Be 0
    }

    It 'rejects an unknown option key, check, or surface' -Tag 'ADR-REPO-VOCAB#2' {
        $body = [ordered]@{ 'widget suite' = (& $script:concept) }
        { & $script:make ([ordered]@{ options = @{ colour = 'blue' }; concepts = $body }) } | Should -Throw "*unknown key 'colour'*"
        { & $script:make ([ordered]@{ options = @{ checks = @('widget') }; concepts = $body }) } | Should -Throw "*options.checks: 'widget' is not one of*"
        { & $script:make ([ordered]@{ options = @{ surfaces = @('gadget') }; concepts = $body }) } | Should -Throw "*options.surfaces: 'gadget' is not one of*"
    }

    It 'rejects a scope or exclude glob that is not repo-relative' -Tag 'ADR-REPO-VOCAB#3' {
        $body = [ordered]@{ 'widget suite' = (& $script:concept) }
        foreach ($glob in '/docs/**', '../widget/**', 'C:/widget/**', 'docs\widget') {
            { & $script:make ([ordered]@{ options = @{ scope = @($glob) }; concepts = $body }) } |
                Should -Throw '*must be a repo-relative*' -Because "'$glob' leaves the repository or is not '/'-separated"
        }
    }

    It 'rejects a URL anywhere in the source' -Tag 'ADR-REPO-VOCAB#3' {
        $body = & $script:concept
        $body.short = 'See https://widget.invalid for the definition.'
        { & $script:single $body } | Should -Throw '*concepts.widget suite.short: a glossary stays in the repository*'

        $body = & $script:concept
        $body.realized_by.pattern = 'https://widget.invalid/suites'
        { & $script:single $body } | Should -Throw '*no URLs*'
    }

    It 'rejects an unknown top-level key and an empty or missing concepts map' {
        { & $script:make ([ordered]@{ widgets = 1; concepts = [ordered]@{ 'widget suite' = (& $script:concept) } }) } |
            Should -Throw "*unknown top-level key 'widgets'*"
        { & $script:make ([ordered]@{ concepts = [ordered]@{} }) } | Should -Throw '*non-empty*concepts*'
        { & $script:make ([ordered]@{ options = @{} }) } | Should -Throw '*non-empty*concepts*'
    }

    It 'names every missing required field of a concept in one throw' -Tag 'ADR-REPO-VOCAB#1' {
        $thrown = { & $script:single ([ordered]@{}) } | Should -Throw -PassThru
        $message = $thrown.Exception.Message
        foreach ($field in 'key', 'domain', 'defined_by', 'short', 'realized_by') {
            $message | Should -BeLike "*$field is required*" -Because "the missing '$field' must be reported in the same throw"
        }
    }

    It 'rejects a malformed term, key, domain, or rule citation' -Tag 'ADR-REPO-VOCAB#1' {
        { & $script:single (& $script:concept) 'Widget Suite' } | Should -Throw '*lower-case words*'
        { & $script:single (& $script:concept) 'widget  suite' } | Should -Throw '*lower-case words*'

        $body = & $script:concept
        $body.key = 'WidgetSuite'
        { & $script:single $body } | Should -Throw "*key 'WidgetSuite' must be snake_case*"

        $body = & $script:concept
        $body.domain = 'Automation'
        { & $script:single $body } | Should -Throw "*domain 'Automation'*"

        foreach ($citation in 'ADR-COG-GADGET:30', 'ADR-COG-GADGET#0', 'ADR-COG#3', 'adr-cog-gadget#3') {
            $body = & $script:concept
            $body.defined_by = $citation
            { & $script:single $body } | Should -Throw '*must be a rule citation*' -Because "'$citation' is not the '#' citation form"
        }
    }

    It 'keeps declared forms in order, empty when none, and rejects a non-word or a repeated form' -Tag 'ADR-REPO-VOCAB#8' {
        (& $script:single (& $script:concept)).concepts[0].forms.Count | Should -Be 0
        $body = & $script:concept
        $body.forms = @('gadget', 'CI')
        (& $script:single $body).concepts[0].forms | Should -Be @('gadget', 'CI')
        $body.forms = @('gadget run', 'ci', 'CI')
        $thrown = { & $script:single $body } | Should -Throw -PassThru
        $thrown.Exception.Message | Should -BeLike "*forms: 'gadget run' must be one word*"
        $thrown.Exception.Message | Should -BeLike "*forms: 'CI' is listed twice*"
        $body.forms = 'gadget'
        { & $script:single $body } | Should -Throw '*forms must be a list of single qualifier words*'
    }

    It 'reads verbs as a flag, false unless set' -Tag 'ADR-REPO-VOCAB#8' {
        (& $script:single (& $script:concept)).concepts[0].verbs | Should -BeFalse
        $body = & $script:concept
        $body.verbs = $true
        (& $script:single $body).concepts[0].verbs | Should -BeTrue
    }

    It 'rejects an unknown concept key' {
        $body = & $script:concept
        $body.synonyms = @('widget bundle')
        { & $script:single $body } | Should -Throw "*unknown key 'synonyms'*"
    }

    It 'requires a known realization kind, a pattern for code kinds, and none for prose-only' -Tag 'ADR-REPO-VOCAB#6' {
        $body = & $script:concept
        $body.realized_by = @{ kind = 'widget'; pattern = 'x' }
        { & $script:single $body } | Should -Throw "*kind 'widget' is not one of*"

        $body = & $script:concept
        $body.realized_by = @{ kind = 'tag' }
        { & $script:single $body } | Should -Throw "*kind 'tag' requires a 'pattern'*"

        $body = & $script:concept
        $body.realized_by = @{ kind = 'prose-only'; pattern = 'x' }
        { & $script:single $body } | Should -Throw '*prose-only concept carries no*'

        $body = & $script:concept
        $body.realized_by = @{ kind = 'prose-only' }
        (& $script:single $body).concepts[0].realized_by.pattern | Should -BeNullOrEmpty
    }

    It 'requires a replacement for every avoided phrase and normalizes the phrase' -Tag 'ADR-REPO-VOCAB#5' {
        $body = & $script:concept
        $body.avoid = @(@{ phrase = 'widget bundle' })
        { & $script:single $body } | Should -Throw '*say is required*'

        $body = & $script:concept
        $body.avoid = @(@{ phrase = '  Widget   Bundle '; say = 'widget suite' })
        $avoid = (& $script:single $body).concepts[0].avoid[0]
        $avoid.phrase | Should -Be 'widget bundle'
        $avoid.say | Should -Be 'widget suite'
    }

    It 'rejects an avoided phrase that is itself a defined term' -Tag 'ADR-REPO-VOCAB#5' {
        $gadget = & $script:concept
        $gadget.key = 'gadget_run'
        $widget = & $script:concept
        $widget.avoid = @(@{ phrase = 'Gadget Run'; say = 'widget suite' })
        { & $script:make ([ordered]@{ concepts = [ordered]@{ 'widget suite' = $widget; 'gadget run' = $gadget } }) } |
            Should -Throw "*avoided phrase 'gadget run' is itself a defined term*"
    }

    It 'requires every contrast to explain the difference, and forbids a self-contrast' -Tag 'ADR-REPO-VOCAB#4' {
        $body = & $script:concept
        $body.contrasts = @{ 'gadget run' = ' ' }
        { & $script:single $body } | Should -Throw "*'gadget run' needs a sentence*"

        $body = & $script:concept
        $body.contrasts = @{ 'widget suite' = 'Itself.' }
        { & $script:single $body } | Should -Throw '*cannot contrast with itself*'

        $body = & $script:concept
        $body.contrasts = [ordered]@{ 'gadget run' = 'A gadget run executes; a widget suite is files at rest.' }
        (& $script:single $body).concepts[0].contrasts['gadget run'] | Should -BeLike 'A gadget run executes*'
    }

    It 'parses relations of the known kinds and rejects an unknown one' {
        $body = & $script:concept
        $body.relations = [ordered]@{ part_of = @('widget module'); selected_by = @('gadget run') }
        $relations = (& $script:single $body).concepts[0].relations
        $relations['part_of'] | Should -Be @('widget module')
        $relations['selected_by'] | Should -Be @('gadget run')

        $body = & $script:concept
        $body.relations = @{ owns = @('gadget run') }
        { & $script:single $body } | Should -Throw "*relations: 'owns' is not one of*"
    }

    It 'rejects a machine key duplicated within the source' {
        $twin = & $script:concept
        { & $script:make ([ordered]@{ concepts = [ordered]@{ 'widget suite' = (& $script:concept); 'gadget run' = $twin } }) } |
            Should -Throw "*key 'widget_suite' duplicates concept 'widget suite'*"
    }
}
