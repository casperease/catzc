Describe 'JavaScriptConfig' -Tag 'L0', 'logic' {
    It 'takes a declared root and resolves to it' {
        $config = [Catzc.Base.Languages.JavaScriptConfig]::new([ordered]@{ root = 'tools/widgets' })
        $config.root | Should -Be 'tools/widgets'
        $config.ResolveRoot($TestDrive) | Should -Be 'tools/widgets'
    }

    It 'resolves to js/ when the repository has it and to the dot-prefixed fallback when not, with no root declared' {
        $config = [Catzc.Base.Languages.JavaScriptConfig]::new($null)
        $config.root | Should -BeNullOrEmpty
        $bare = Join-Path $TestDrive 'bare'
        $null = New-Item -ItemType Directory -Path $bare -Force
        $config.ResolveRoot($bare) | Should -Be ([Catzc.Base.Languages.JavaScriptConfig]::FallbackRoot)
        $null = New-Item -ItemType Directory -Path (Join-Path $bare 'js') -Force
        $config.ResolveRoot($bare) | Should -Be ([Catzc.Base.Languages.JavaScriptConfig]::DefaultRoot)
        { $config.ResolveRoot('') } | Should -Throw '*requires the repository root*'
    }

    It 'raises no module by default, takes the kebab module names listed, and refuses any other entry or a repeat' {
        @(([Catzc.Base.Languages.JavaScriptConfig]::new($null)).strict) | Should -HaveCount 0
        @(([Catzc.Base.Languages.JavaScriptConfig]::new([ordered]@{ strict = @('catzc-widget', 'gadget') })).strict) |
            Should -Be @('catzc-widget', 'gadget')
        { [Catzc.Base.Languages.JavaScriptConfig]::new([ordered]@{ strict = 'catzc-widget' }) } |
            Should -Throw '*must be a list*'
        { [Catzc.Base.Languages.JavaScriptConfig]::new([ordered]@{ strict = @('Catzc.Widget') }) } |
            Should -Throw '*not a kebab module folder name*'
        { [Catzc.Base.Languages.JavaScriptConfig]::new([ordered]@{ strict = @('gadget', 'gadget') }) } |
            Should -Throw "*lists 'gadget' twice*"
    }

    It 'refuses an unknown key and a root that is not a repository-relative folder' {
        { [Catzc.Base.Languages.JavaScriptConfig]::new([ordered]@{ gadget = 1 }) } |
            Should -Throw "*unknown key 'gadget'*"
        foreach ($root in '/js', 'js/', '../js', 'js/./widgets', 'C:\js') {
            { [Catzc.Base.Languages.JavaScriptConfig]::new([ordered]@{ root = $root }) } |
                Should -Throw '*invalid root*' -Because "'$root' is no repository-relative folder"
        }
    }
}
