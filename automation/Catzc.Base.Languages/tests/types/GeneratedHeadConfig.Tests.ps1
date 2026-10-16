<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.Languages/tests/types/GeneratedHeadConfig.Tests.ps1
    folder: tests/types
    name: generated-head-config-tests
    filetype: ps1
    kind: test
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.Languages
    moduletype: pwsh-folder
    catzc_bundle: azure
---
#>

Describe 'Catzc.Base.Languages.GeneratedHeadConfig' -Tag 'L0', 'logic' {
    It 'keeps the keys in the order the registry lists them' {
        $config = [Catzc.Base.Languages.GeneratedHeadConfig]::new([ordered]@{ keys = @('path', 'source', 'kind', 'generator') })
        $config.order | Should -Be @('path', 'source', 'kind', 'generator')
    }

    It 'rejects an unknown key, a repeated key, a missing required key and an unknown top-level key' {
        { [Catzc.Base.Languages.GeneratedHeadConfig]::new([ordered]@{ keys = @('path', 'kind', 'widget') }) } | Should -Throw '*unknown head key ''widget''*'
        { [Catzc.Base.Languages.GeneratedHeadConfig]::new([ordered]@{ keys = @('path', 'kind', 'kind') }) } | Should -Throw '*listed once*'
        { [Catzc.Base.Languages.GeneratedHeadConfig]::new([ordered]@{ keys = @('path', 'source') }) } | Should -Throw '*''kind'' is required*'
        { [Catzc.Base.Languages.GeneratedHeadConfig]::new([ordered]@{ keys = @('path', 'kind'); widget = 1 }) } | Should -Throw '*unknown top-level key*'
    }

    It 'holds no kind of its own: the kind of a generated file is the role the file-kinds registry names' {
        { [Catzc.Base.Languages.GeneratedHeadConfig]::new([ordered]@{ keys = @('path', 'kind'); kind = 'generated-from-source' }) } | Should -Throw '*unknown top-level key*'
        { [Catzc.Base.Languages.GeneratedHeadConfig]::new([ordered]@{ keys = @('path', 'kind'); tracked_kind = 'tracked' }) } | Should -Throw '*unknown top-level key*'
    }

    It 'knows the subkind key' {
        [Catzc.Base.Languages.GeneratedHeadConfig]::new([ordered]@{ keys = @('path', 'kind', 'subkind') }).order | Should -Be @('path', 'kind', 'subkind')
    }

    It 'knows the inputs stamp key' {
        [Catzc.Base.Languages.GeneratedHeadConfig]::new([ordered]@{ keys = @('with_inputs_sha', 'path', 'kind') }).order | Should -Be @('with_inputs_sha', 'path', 'kind')
    }

    It 'loads the shipped generated-head.yml' {
        (Get-Config -Config generated-head).order | Should -Be @('with_body_sha', 'with_inputs_sha', 'repo_status', 'path', 'source', 'kind', 'subkind', 'language', 'filetype', 'track', 'tracktype', 'vendor', 'module', 'moduletype', 'generator')
    }
}
