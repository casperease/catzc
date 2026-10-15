<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Languages/tests/types/GeneratedHeadConfig.Tests.ps1
    kind: test
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

    It 'declares both kinds once, and refuses two equal kinds' {
        $config = [Catzc.Base.Languages.GeneratedHeadConfig]::new([ordered]@{ keys = @('path', 'kind') })
        $config.kind | Should -Be 'generated-from-source'
        $config.tracked_kind | Should -Be 'tracked-generated-from-source'
        { [Catzc.Base.Languages.GeneratedHeadConfig]::new([ordered]@{ keys = @('path', 'kind'); kind = 'a'; tracked_kind = 'a' }) } | Should -Throw '*differ*'
    }

    It 'loads the shipped generated-head.yml' {
        (Get-Config -Config generated-head).order | Should -Be @('path', 'source', 'kind', 'generator')
    }
}
