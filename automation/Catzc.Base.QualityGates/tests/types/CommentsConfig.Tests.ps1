<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/tests/types/CommentsConfig.Tests.ps1
    kind: pester-test
    relatives:
      page: docs/references/automation/catzc-base-qualitygates/tests/types/CommentsConfig.Tests.ps1.md
      source: automation/Catzc.Base.QualityGates/types/CommentsConfig.cs
    adrs:
      - ADR-AUTO-DEFAULT#6
      - ADR-CONF-LOADING#4
      - ADR-PRIN-CONFIG#1
      - ADR-REPO-COMMENTS#3
---
#>

Describe 'CommentsConfig' -Tag 'L0', 'logic' {
    It 'takes the declared defaults for every omitted key' -Tag 'ADR-AUTO-DEFAULT#6' {
        $config = [Catzc.Base.QualityGates.CommentsConfig]::new(@{})
        $config.languages | Should -Be @('powershell', 'yaml', 'pipeline-yaml', 'csharp', 'bicep')
        $config.min_lines | Should -Be 2
        $config.KeepFor('powershell') | Should -Contain '.SYNOPSIS'
        $config.KeepFor('bicep') | Should -Be @('// cspell:')
        $config.IsKept('yaml', '# cspell:ignore widgt') | Should -BeTrue
        $config.KeepFor('gadget').Count | Should -Be 0
        $config.pages.Count | Should -Be 4
        $config.pages[0].source | Should -Be 'automation/*'
        $config.view | Should -Be 'out/annotated'
        $config.IsExcluded('automation/Catzc.Widget/tests/Get-Widget.Tests.ps1') | Should -BeTrue
        $config.IsExcluded('automation/Catzc.Widget/assets/root/widget.yml') | Should -BeTrue
        $config.IsExcluded('automation/Catzc.Widget/Get-Widget.ps1') | Should -BeFalse
    }

    It 'replaces the exclude map when given, and rejects one without a reason or with a bad glob' -Tag 'ADR-REPO-COMMENTS#3' {
        $config = [Catzc.Base.QualityGates.CommentsConfig]::new(@{ exclude = @{ 'automation/*/gadgets/**' = 'gadgets are generated' } })
        $config.IsExcluded('automation/Catzc.Widget/gadgets/one.ps1') | Should -BeTrue
        $config.IsExcluded('automation/Catzc.Widget/tests/Get-Widget.Tests.ps1') | Should -BeFalse
        { [Catzc.Base.QualityGates.CommentsConfig]::new(@{ exclude = @{ '**/gadgets/**' = '' } }) } | Should -Throw '*needs a reason*'
        { [Catzc.Base.QualityGates.CommentsConfig]::new(@{ exclude = @{ '/gadgets' = 'rooted' } }) } | Should -Throw '*not a valid glob*'
        { [Catzc.Base.QualityGates.CommentsConfig]::new(@{ exclude = 'gadgets' }) } | Should -Throw '*exclude must be a map*'
    }

    It 'maps a file to its comment page: the extension stays, the module folder is kebab-cased' -Tag 'ADR-REPO-COMMENTS#3' {
        $config = [Catzc.Base.QualityGates.CommentsConfig]::new(@{})
        $config.PageFor('automation/Catzc.Widget.Gadgets/private/Get-Gadget.ps1') |
            Should -Be 'docs/references/automation/catzc-widget-gadgets/private/Get-Gadget.ps1.md'
        $config.PageFor('automation/Catzc.Widget.Gadgets/configs/gadgets.yml') |
            Should -Be 'docs/references/automation/catzc-widget-gadgets/configs/gadgets.yml.md'
        $config.PageFor('pipelines/widget/build.yaml') | Should -Be 'docs/references/pipelines/widget/build.yaml.md'
        $config.PageFor('.claude/hooks/Gadget/Program.cs') | Should -Be 'docs/references/automation/claude-hooks/Gadget/Program.cs.md'
    }

    It 'maps no page for a file outside every source, a dot-prefixed module folder, or a file directly in the prefix' -Tag 'ADR-REPO-COMMENTS#3' {
        $config = [Catzc.Base.QualityGates.CommentsConfig]::new(@{})
        $config.PageFor('docs/adr/index.md') | Should -BeNullOrEmpty
        $config.PageFor('automation/.vendor/Gadget/Gadget.psm1') | Should -BeNullOrEmpty
        $config.PageFor('automation/importer.ps1') | Should -BeNullOrEmpty
        $config.PageFor('automation/Catzc.Widget.Gadgets') | Should -BeNullOrEmpty
        $config.PageFor('') | Should -BeNullOrEmpty
    }

    It 'lets the first matching pages entry win and takes a plain folder map as given' -Tag 'ADR-PRIN-CONFIG#1' {
        $config = [Catzc.Base.QualityGates.CommentsConfig]::new(@{
                pages = @(
                    [ordered]@{ source = 'automation/Catzc.Widget.Gadgets'; docs = 'docs/references/gadgets' },
                    [ordered]@{ source = 'automation/*'; docs = 'docs/references/automation/{kebab}' }
                )
            })
        $config.PageFor('automation/Catzc.Widget.Gadgets/Get-Gadget.ps1') | Should -Be 'docs/references/gadgets/Get-Gadget.ps1.md'
        $config.PageFor('automation/Catzc.Widget.Other/Get-Gadget.ps1') | Should -Be 'docs/references/automation/catzc-widget-other/Get-Gadget.ps1.md'
    }

    It 'maps every key it is given, replacing a language''s keep list but not the others' -Tag 'ADR-PRIN-CONFIG#1' {
        $config = [Catzc.Base.QualityGates.CommentsConfig]::new(@{
                languages = @('powershell')
                min_lines = 3
                keep      = @{ powershell = @('.SYNOPSIS') }
                view      = 'out/gadget-view'
            })
        $config.languages | Should -Be @('powershell')
        $config.min_lines | Should -Be 3
        $config.KeepFor('powershell') | Should -Be @('.SYNOPSIS')
        $config.KeepFor('csharp') | Should -Be @('// <auto-generated', '// cspell:')
        $config.IsKept('powershell', '    .synopsis') | Should -BeTrue
        $config.IsKept('powershell', '#Requires -Version 7') | Should -BeFalse
        $config.view | Should -Be 'out/gadget-view'
    }

    It 'keeps no run by default, and maps a language''s keep_run heads case-insensitively' -Tag 'ADR-REPO-COMMENTS#3' {
        $default = [Catzc.Base.QualityGates.CommentsConfig]::new(@{})
        $default.keep_run.Count | Should -Be 0
        $default.IsKeptRun('csharp', '// catzc:') | Should -BeFalse
        $config = [Catzc.Base.QualityGates.CommentsConfig]::new(@{ keep_run = @{ csharp = @('// catzc:'); powershell = @('# catzc:') } })
        $config.IsKeptRun('csharp', '  // CATZC:') | Should -BeTrue
        $config.IsKeptRun('powershell', '# catzc:') | Should -BeTrue
        $config.IsKeptRun('powershell', '// catzc:') | Should -BeFalse
        $config.IsKeptRun('yaml', '# catzc:') | Should -BeFalse
        $config.IsKept('csharp', '// catzc:') | Should -BeFalse -Because 'a run head is not a single kept line'
    }

    It 'rejects an unknown key, naming the allowed set' -Tag 'ADR-AUTO-DEFAULT#6' {
        { [Catzc.Base.QualityGates.CommentsConfig]::new(@{ gadget = 1 }) } | Should -Throw '*unknown key*languages, min_lines*'
    }

    It 'rejects a malformed value, naming its key' -Tag 'ADR-AUTO-DEFAULT#6' {
        { [Catzc.Base.QualityGates.CommentsConfig]::new(@{ min_lines = 0 }) } | Should -Throw '*min_lines must be a positive integer*'
        { [Catzc.Base.QualityGates.CommentsConfig]::new(@{ languages = @() }) } | Should -Throw '*languages must name at least one*'
        { [Catzc.Base.QualityGates.CommentsConfig]::new(@{ languages = @('yaml', 'YAML') }) } | Should -Throw "*lists 'yaml' twice*"
        { [Catzc.Base.QualityGates.CommentsConfig]::new(@{ keep = 'widget' }) } | Should -Throw '*keep must be a map*'
        { [Catzc.Base.QualityGates.CommentsConfig]::new(@{ keep = @{ powershell = 'widget' } }) } | Should -Throw '*keep.powershell must be a list*'
        { [Catzc.Base.QualityGates.CommentsConfig]::new(@{ keep_run = 'widget' }) } | Should -Throw '*keep_run must be a map*'
        { [Catzc.Base.QualityGates.CommentsConfig]::new(@{ keep_run = @{ csharp = 'widget' } }) } | Should -Throw '*keep_run.csharp must be a list*'
        { [Catzc.Base.QualityGates.CommentsConfig]::new(@{ view = 'docs/view' }) } | Should -Throw '*view*must be a folder under out/*'
        { [Catzc.Base.QualityGates.CommentsConfig]::new(@{ pages = @() }) } | Should -Throw '*pages must be a non-empty list*'
    }

    It 'rejects a pages entry that is not a folder map with a docs folder' -Tag 'ADR-PRIN-CONFIG#1' {
        # A '[' in a -Throw pattern is a wildcard class, so the index brackets are escaped.
        { [Catzc.Base.QualityGates.CommentsConfig]::new(@{ pages = @('widget') }) } | Should -Throw '*pages`[0`]*must be a map*'
        { [Catzc.Base.QualityGates.CommentsConfig]::new(@{ pages = @(@{ source = 'widget' }) }) } | Should -Throw '*pages`[0`]*docs is required*'
        { [Catzc.Base.QualityGates.CommentsConfig]::new(@{ pages = @(@{ source = 'widget'; docs = 'notes/widget' }) }) } |
            Should -Throw '*must be a folder under docs/*'
        { [Catzc.Base.QualityGates.CommentsConfig]::new(@{ pages = @(@{ source = 'widget/**'; docs = 'docs/widget' }) }) } |
            Should -Throw "*only a trailing '/*' is supported*"
        { [Catzc.Base.QualityGates.CommentsConfig]::new(@{ pages = @(@{ source = 'widget'; docs = 'docs/{kebab}' }) }) } |
            Should -Throw "*needs a source ending in '/*'*"
        { [Catzc.Base.QualityGates.CommentsConfig]::new(@{ pages = @(@{ source = '/widget'; docs = 'docs/widget' }) }) } |
            Should -Throw '*no leading or trailing*'
        { [Catzc.Base.QualityGates.CommentsConfig]::new(@{ pages = @(@{ source = 'widget'; docs = 'docs/widget'; gadget = 1 }) }) } |
            Should -Throw '*unknown key*source, docs*'
    }
}

Describe 'CommentsConfig (shipped comments.yml)' -Tag 'L1', 'integrity' {
    It 'loads the shipped comments.yml as a CommentsConfig' -Tag 'ADR-CONF-LOADING#4' {
        (Get-Config -Config comments) | Should -BeOfType ([Catzc.Base.QualityGates.CommentsConfig])
    }
}
