Describe 'Catzc.Base.Languages.GeneratedHeadConfig' -Tag 'L0', 'logic' {
    It 'keeps the keys in the order the registry lists them' {
        [Catzc.Base.Languages.GeneratedHeadConfig]::new([ordered]@{ keys = @('warning', 'with_body_sha') }).order |
            Should -Be @('warning', 'with_body_sha')
        [Catzc.Base.Languages.GeneratedHeadConfig]::new([ordered]@{ keys = @('with_body_sha', 'warning') }).order |
            Should -Be @('with_body_sha', 'warning')
    }

    It 'rejects an unknown key, a repeated key, a missing required key and an unknown top-level key' {
        { [Catzc.Base.Languages.GeneratedHeadConfig]::new([ordered]@{ keys = @('warning', 'with_body_sha',
                        'widget')
                }) } | Should -Throw '*unknown head key ''widget''*'
        { [Catzc.Base.Languages.GeneratedHeadConfig]::new([ordered]@{ keys = @('warning', 'with_body_sha',
                        'warning')
                }) } | Should -Throw '*listed once*'
        { [Catzc.Base.Languages.GeneratedHeadConfig]::new([ordered]@{ keys = @('warning') }) } |
            Should -Throw '*''with_body_sha'' is required*'
        { [Catzc.Base.Languages.GeneratedHeadConfig]::new([ordered]@{ keys = @('with_body_sha') }) } |
            Should -Throw '*''warning'' is required*'
        { [Catzc.Base.Languages.GeneratedHeadConfig]::new([ordered]@{ keys = @('warning',
                        'with_body_sha'); widget                           = 1
                }) } | Should -Throw '*unknown top-level key*'
    }

    It 'rejects every fact a generated head no longer carries, since each is derived on demand' -Tag 'ADR-REPO-FILEMETA-COMPOSEDFILES' -ForEach @(
        @{ Key = 'role' }, @{ Key = 'track' }, @{ Key = 'generator' }, @{ Key = 'source' }, @{ Key = 'with_inputs_sha' }
        @{ Key = 'repo_status' }, @{ Key = 'path' }, @{ Key = 'subkind' }, @{ Key = 'language' }, @{ Key = 'module' }
    ) {
        { [Catzc.Base.Languages.GeneratedHeadConfig]::new([ordered]@{ keys = @('warning', 'with_body_sha', $Key) }) } |
            Should -Throw "*unknown head key '$Key'*"
    }

    It 'declares the one warning once, as a default a config may replace, and a blank value keeps the default' {
        $keys = @('warning', 'with_body_sha')
        [Catzc.Base.Languages.GeneratedHeadConfig]::new([ordered]@{ keys = $keys }).warning |
            Should -BeExactly 'Do Not Edit, this file is generated'
        [Catzc.Base.Languages.GeneratedHeadConfig]::new([ordered]@{ keys = $keys; warning = 'widget' }).warning |
            Should -BeExactly 'widget'
        [Catzc.Base.Languages.GeneratedHeadConfig]::new([ordered]@{ keys = $keys; warning = ' ' }).warning |
            Should -BeExactly 'Do Not Edit, this file is generated'
    }

    It 'loads the shipped generated-head.yml: the body hash first, so the head reads immutable for this body, then the warning' -Tag 'ADR-REPO-FILEMETA-COMPOSEDFILES' {
        (Get-Config -Config generated-head).order | Should -Be @('with_body_sha', 'warning')
    }
}
