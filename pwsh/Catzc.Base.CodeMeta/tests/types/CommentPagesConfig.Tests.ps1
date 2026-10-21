<#
---
catzc:
  immutable:
    with_body_sha: "5ca183b62672"
  edges:
    code: pwsh/Catzc.Base.CodeMeta/types/CommentPagesConfig.cs
    cites:
      - ADR-AUTO-DEFAULT-ONERESOLUTIONORDER
      - ADR-REPO-COMMENTS-COMMENTPAGEPLACE
      - PDR-CONFIG-VARYINGBEHAVIOURISCONFIG
---
#>

Describe 'CommentPagesConfig' -Tag 'L0', 'logic' {
    It 'takes the declared default pages when the key is omitted' -Tag 'ADR-AUTO-DEFAULT-ONERESOLUTIONORDER' {
        $config = [Catzc.Base.CodeMeta.CommentPagesConfig]::new(@{})
        $config.pages.Count | Should -Be 4
        $config.pages[0].source | Should -Be 'pwsh/*'
    }

    It 'maps a file to its comment page: the extension stays, the module folder is kebab-cased' -Tag 'ADR-REPO-COMMENTS-COMMENTPAGEPLACE' {
        $config = [Catzc.Base.CodeMeta.CommentPagesConfig]::new(@{})
        $config.PageFor('pwsh/Catzc.Widget.Gadgets/private/Get-Gadget.ps1') |
            Should -Be 'docs/references/pwsh/catzc-widget-gadgets/private/Get-Gadget.ps1.md'
        $config.PageFor('pwsh/Catzc.Widget.Gadgets/configs/gadgets.yml') |
            Should -Be 'docs/references/pwsh/catzc-widget-gadgets/configs/gadgets.yml.md'
        $config.PageFor('.ado/pipelines/widget/build.yaml') | Should -Be 'docs/references/ado/pipelines/widget/build.yaml.md'
        $config.PageFor('.claude/hooks/Gadget/Program.cs') | Should -Be 'docs/references/pwsh/claude-hooks/Gadget/Program.cs.md'
    }

    It 'maps no page for a file outside every source, a dot-prefixed module folder, or a file directly in the prefix' -Tag 'ADR-REPO-COMMENTS-COMMENTPAGEPLACE' {
        $config = [Catzc.Base.CodeMeta.CommentPagesConfig]::new(@{})
        $config.PageFor('docs/adr/index.md') | Should -BeNullOrEmpty
        $config.PageFor('pwsh/.vendor/Gadget/Gadget.psm1') | Should -BeNullOrEmpty
        $config.PageFor('pwsh/importer.ps1') | Should -BeNullOrEmpty
        $config.PageFor('pwsh/Catzc.Widget.Gadgets') | Should -BeNullOrEmpty
        $config.PageFor('') | Should -BeNullOrEmpty
    }

    It 'lets the first matching pages entry win and takes a plain folder map as given' -Tag 'PDR-CONFIG-VARYINGBEHAVIOURISCONFIG' {
        $config = [Catzc.Base.CodeMeta.CommentPagesConfig]::new(@{
                pages = @(
                    [ordered]@{ source = 'widgets/Catzc.Widget.Gadgets'; docs = 'docs/references/gadgets' },
                    [ordered]@{ source = 'widgets/*'; docs = 'docs/references/widgets/{kebab}' }
                )
            })
        $config.PageFor('widgets/Catzc.Widget.Gadgets/Get-Gadget.ps1') | Should -Be 'docs/references/gadgets/Get-Gadget.ps1.md'
        $config.PageFor('widgets/Catzc.Widget.Other/Get-Gadget.ps1') | Should -Be 'docs/references/widgets/catzc-widget-other/Get-Gadget.ps1.md'
    }

    It 'rejects an unknown key, naming the allowed set' -Tag 'ADR-AUTO-DEFAULT-ONERESOLUTIONORDER' {
        { [Catzc.Base.CodeMeta.CommentPagesConfig]::new(@{ gadget = 1 }) } | Should -Throw '*unknown key*allowed: pages*'
    }

    It 'rejects an empty pages list' -Tag 'ADR-AUTO-DEFAULT-ONERESOLUTIONORDER' {
        { [Catzc.Base.CodeMeta.CommentPagesConfig]::new(@{ pages = @() }) } | Should -Throw '*pages must be a non-empty list*'
    }

    It 'rejects a pages entry that is not a folder map with a docs folder' -Tag 'PDR-CONFIG-VARYINGBEHAVIOURISCONFIG' {
        # A '[' in a -Throw pattern is a wildcard class, so the index brackets are escaped.
        { [Catzc.Base.CodeMeta.CommentPagesConfig]::new(@{ pages = @('widget') }) } | Should -Throw '*pages`[0`]*must be a map*'
        { [Catzc.Base.CodeMeta.CommentPagesConfig]::new(@{ pages = @(@{ source = 'widget' }) }) } | Should -Throw '*pages`[0`]*docs is required*'
        { [Catzc.Base.CodeMeta.CommentPagesConfig]::new(@{ pages = @(@{ source = 'widget'; docs = 'notes/widget' }) }) } |
            Should -Throw '*must be a folder under docs/*'
        { [Catzc.Base.CodeMeta.CommentPagesConfig]::new(@{ pages = @(@{ source = 'widget/**'; docs = 'docs/widget' }) }) } |
            Should -Throw "*only a trailing '/*' is supported*"
        { [Catzc.Base.CodeMeta.CommentPagesConfig]::new(@{ pages = @(@{ source = 'widget'; docs = 'docs/{kebab}' }) }) } |
            Should -Throw "*needs a source ending in '/*'*"
        { [Catzc.Base.CodeMeta.CommentPagesConfig]::new(@{ pages = @(@{ source = '/widget'; docs = 'docs/widget' }) }) } |
            Should -Throw '*no leading or trailing*'
        { [Catzc.Base.CodeMeta.CommentPagesConfig]::new(@{ pages = @(@{ source = 'widget'; docs = 'docs/widget'; gadget = 1 }) }) } |
            Should -Throw '*unknown key*source, docs*'
    }
}
