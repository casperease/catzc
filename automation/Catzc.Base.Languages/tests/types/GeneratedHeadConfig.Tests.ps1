Describe 'Catzc.Base.Languages.GeneratedHeadConfig' -Tag 'L0', 'logic' {
    It 'keeps the keys in the order the registry lists them' {
        $config = [Catzc.Base.Languages.GeneratedHeadConfig]::new([ordered]@{ keys = @('path', 'source', 'role', 'generator') })
        $config.order | Should -Be @('path', 'source', 'role', 'generator')
    }

    It 'rejects an unknown key, a repeated key, a missing required key and an unknown top-level key' {
        { [Catzc.Base.Languages.GeneratedHeadConfig]::new([ordered]@{ keys = @('path', 'role', 'widget') }) } | Should -Throw '*unknown head key ''widget''*'
        { [Catzc.Base.Languages.GeneratedHeadConfig]::new([ordered]@{ keys = @('path', 'role', 'role') }) } | Should -Throw '*listed once*'
        { [Catzc.Base.Languages.GeneratedHeadConfig]::new([ordered]@{ keys = @('path', 'source') }) } | Should -Throw '*''role'' is required*'
        { [Catzc.Base.Languages.GeneratedHeadConfig]::new([ordered]@{ keys = @('path', 'role'); widget = 1 }) } | Should -Throw '*unknown top-level key*'
    }

    It 'holds no role of its own: the role of a generated file is what the file-kinds registry names' {
        { [Catzc.Base.Languages.GeneratedHeadConfig]::new([ordered]@{ keys = @('path', 'role'); kind = 'generated-from-source' }) } | Should -Throw '*unknown top-level key*'
        { [Catzc.Base.Languages.GeneratedHeadConfig]::new([ordered]@{ keys = @('path', 'role'); tracked_kind = 'tracked' }) } | Should -Throw '*unknown top-level key*'
    }

    It 'knows the subkind key' {
        [Catzc.Base.Languages.GeneratedHeadConfig]::new([ordered]@{ keys = @('path', 'role', 'subkind') }).order | Should -Be @('path', 'role', 'subkind')
    }

    It 'knows the inputs stamp key' {
        [Catzc.Base.Languages.GeneratedHeadConfig]::new([ordered]@{ keys = @('with_inputs_sha', 'path', 'role') }).order | Should -Be @('with_inputs_sha', 'path', 'role')
    }

    It 'loads the shipped generated-head.yml' {
        (Get-Config -Config generated-head).order | Should -Be @('with_body_sha', 'with_inputs_sha', 'repo_status', 'path', 'source', 'role', 'subkind', 'language', 'filetype', 'track', 'tracktype', 'vendor', 'module', 'moduletype', 'generator')
    }
}
