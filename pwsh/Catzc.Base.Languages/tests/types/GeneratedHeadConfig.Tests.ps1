<#
---
catzc:
  immutable:
    with_body_sha: "4ea3b7e99ab0"
  edges:
    code: pwsh/Catzc.Base.Languages/types/GeneratedHeadConfig.cs
    cites:
      - ADR-REPO-FILEMETA-IMPRINTEDPARTS
      - ADR-REPO-FILEMETA-COMPOSEDFILES
---
#>

Describe 'Catzc.Base.Languages.GeneratedHeadConfig' -Tag 'L0', 'logic' {
    It 'keeps the keys in the order the registry lists them' {
        $config = [Catzc.Base.Languages.GeneratedHeadConfig]::new([ordered]@{ keys = @('with_body_sha', 'warning', 'role', 'source', 'generator') })
        $config.order | Should -Be @('with_body_sha', 'warning', 'role', 'source', 'generator')
    }

    It 'rejects an unknown key, a repeated key, a missing required key and an unknown top-level key' {
        { [Catzc.Base.Languages.GeneratedHeadConfig]::new([ordered]@{ keys = @('with_body_sha', 'warning', 'role', 'widget') }) } | Should -Throw '*unknown head key ''widget''*'
        { [Catzc.Base.Languages.GeneratedHeadConfig]::new([ordered]@{ keys = @('with_body_sha', 'warning', 'role', 'role') }) } | Should -Throw '*listed once*'
        { [Catzc.Base.Languages.GeneratedHeadConfig]::new([ordered]@{ keys = @('with_body_sha', 'warning', 'source') }) } | Should -Throw '*''role'' is required*'
        { [Catzc.Base.Languages.GeneratedHeadConfig]::new([ordered]@{ keys = @('with_body_sha', 'role') }) } | Should -Throw '*''warning'' is required*'
        { [Catzc.Base.Languages.GeneratedHeadConfig]::new([ordered]@{ keys = @('with_body_sha', 'warning', 'role'); widget = 1 }) } | Should -Throw '*unknown top-level key*'
    }

    It 'holds no role of its own: the role of a generated file is what the file-kinds registry names' {
        { [Catzc.Base.Languages.GeneratedHeadConfig]::new([ordered]@{ keys = @('with_body_sha', 'warning', 'role'); kind = 'generated-from-source' }) } | Should -Throw '*unknown top-level key*'
        { [Catzc.Base.Languages.GeneratedHeadConfig]::new([ordered]@{ keys = @('with_body_sha', 'warning', 'role'); tracked_kind = 'tracked' }) } | Should -Throw '*unknown top-level key*'
    }

    It 'rejects every place fact a head does not carry, since each is derived on demand' -Tag 'ADR-REPO-FILEMETA-COMPOSEDFILES' -ForEach @(
        @{ Key = 'repo_status' }, @{ Key = 'path' }, @{ Key = 'subkind' }, @{ Key = 'language' }, @{ Key = 'filetype' }
        @{ Key = 'tracktype' }, @{ Key = 'vendor' }, @{ Key = 'module' }, @{ Key = 'moduletype' }
    ) {
        { [Catzc.Base.Languages.GeneratedHeadConfig]::new([ordered]@{ keys = @('with_body_sha', 'warning', 'role', $Key) }) } | Should -Throw "*unknown head key '$Key'*"
    }

    It 'rejects the dropped inputs stamp key: the body hash is a head''s one currency fact' -Tag 'ADR-REPO-FILEMETA-IMPRINTEDPARTS' {
        { [Catzc.Base.Languages.GeneratedHeadConfig]::new([ordered]@{ keys = @('with_inputs_sha', 'with_body_sha', 'warning', 'role') }) } | Should -Throw "*unknown head key 'with_inputs_sha'*"
    }

    It 'declares the one warning once, as a default a config may replace, and a blank value keeps the default' {
        $keys = @('with_body_sha', 'warning', 'role')
        [Catzc.Base.Languages.GeneratedHeadConfig]::new([ordered]@{ keys = $keys }).warning | Should -BeExactly 'Do Not Edit, this file is generated'
        [Catzc.Base.Languages.GeneratedHeadConfig]::new([ordered]@{ keys = $keys; warning = 'widget' }).warning | Should -BeExactly 'widget'
        [Catzc.Base.Languages.GeneratedHeadConfig]::new([ordered]@{ keys = $keys; warning = ' ' }).warning | Should -BeExactly 'Do Not Edit, this file is generated'
    }

    It 'loads the shipped generated-head.yml' {
        (Get-Config -Config generated-head).order | Should -Be @('with_body_sha', 'warning', 'role', 'track', 'generator', 'source')
    }
}
