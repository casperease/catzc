Describe 'Catzc.Base.Languages.GeneratedHeadConfig' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:keys = @('warning', 'regenerate', 'with_body_sha')
        $script:make = { param([System.Collections.IDictionary] $Raw) [Catzc.Base.Languages.GeneratedHeadConfig]::new($Raw) }
    }

    It 'keeps the keys in the one order the head is written in, the body hash closing it' -Tag 'ADR-REPO-FILEMETA-COMPOSEDFILES' {
        (& $script:make ([ordered]@{ keys = $script:keys })).order | Should -Be $script:keys
    }

    It 'takes the order from the type when the config lists no keys' -Tag 'ADR-AUTO-DEFAULT-ONERESOLUTIONORDER' {
        (& $script:make ([ordered]@{})).order | Should -Be $script:keys
    }

    It 'rejects the keys in any other order' -Tag 'ADR-REPO-FILEMETA-COMPOSEDFILES' {
        { & $script:make ([ordered]@{ keys = @('with_body_sha', 'warning', 'regenerate') }) } |
            Should -Throw '*written in this order: warning, regenerate, with_body_sha*'
    }

    It 'rejects an unknown key, a repeated key, a missing required key and an unknown top-level key' {
        { & $script:make ([ordered]@{ keys = $script:keys + 'widget' }) } | Should -Throw '*unknown head key ''widget''*'
        { & $script:make ([ordered]@{ keys = $script:keys + 'warning' }) } | Should -Throw '*listed once*'
        foreach ($required in $script:keys) {
            { & $script:make ([ordered]@{ keys = @($script:keys | Where-Object { $_ -ne $required }) }) } |
                Should -Throw "*'$required' is required*"
        }
        { & $script:make ([ordered]@{ keys = $script:keys; widget = 1 }) } | Should -Throw '*unknown top-level key*'
    }

    It 'rejects every fact a generated head no longer carries, since each is derived on demand' -Tag 'ADR-REPO-FILEMETA-COMPOSEDFILES' -ForEach @(
        @{ Key = 'role' }, @{ Key = 'track' }, @{ Key = 'generator' }, @{ Key = 'source' }, @{ Key = 'with_inputs_sha' }
        @{ Key = 'repo_status' }, @{ Key = 'path' }, @{ Key = 'subkind' }, @{ Key = 'language' }, @{ Key = 'module' }
        @{ Key = 'sources' }, @{ Key = 'remove' }
    ) {
        { & $script:make ([ordered]@{ keys = $script:keys + $Key }) } | Should -Throw "*unknown head key '$Key'*"
    }

    It 'rejects a remove template, since the writer registry answers what a roll-off takes' -Tag 'ADR-REPO-FILEMETA-PROVENANCEINHEAD' {
        { & $script:make ([ordered]@{ remove = 'Remove-Generated -Path {path}' }) } | Should -Throw "*unknown top-level key 'remove'*"
    }

    It 'declares the one warning once, as a default a config may replace, and a blank value keeps the default' {
        (& $script:make ([ordered]@{})).warning | Should -BeExactly 'Do Not Edit, this file is generated'
        (& $script:make ([ordered]@{ warning = 'widget' })).warning | Should -BeExactly 'widget'
        (& $script:make ([ordered]@{ warning = ' ' })).warning | Should -BeExactly 'Do Not Edit, this file is generated'
    }

    It 'declares the regenerate template once, as a default a config may replace' -Tag 'ADR-AUTO-DEFAULT-ONERESOLUTIONORDER' {
        (& $script:make ([ordered]@{})).regenerate | Should -BeExactly '{writer} -Path {path}'
        (& $script:make ([ordered]@{ regenerate = 'Build-Widget -Target {writer} {path}' })).regenerate | Should -BeExactly 'Build-Widget -Target {writer} {path}'
        (& $script:make ([ordered]@{ regenerate = ' ' })).regenerate | Should -BeExactly '{writer} -Path {path}'
    }

    It 'rejects a regenerate template that names no {path}, or a placeholder other than {writer} and {path}' {
        { & $script:make ([ordered]@{ regenerate = 'Build-Widget' }) } | Should -Throw "*the regenerate template 'Build-Widget' names no {path}*"
        { & $script:make ([ordered]@{ regenerate = 'Build-Widget -Path {path} -Gadget {gadget}' }) } |
            Should -Throw "*the regenerate template * has the unknown placeholder '{gadget}' (allowed: {writer}, {path})*"
    }

    It 'loads the shipped generated-head.yml in the one order, with the template the type declares' -Tag 'ADR-REPO-FILEMETA-COMPOSEDFILES' {
        $shipped = Get-Config -Config generated-head
        $shipped.order | Should -Be $script:keys
        $shipped.regenerate | Should -BeExactly ([Catzc.Base.Languages.GeneratedHeadConfig]::DefaultRegenerate)
    }
}
