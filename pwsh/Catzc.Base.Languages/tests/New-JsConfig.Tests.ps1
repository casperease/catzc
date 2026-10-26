Describe 'New-JsConfig' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:root = Join-Path $TestDrive 'repo'
        $null = New-Item -ItemType Directory -Path (Join-Path $script:root 'js/catzc-widget') -Force
        Mock Get-Config -ModuleName Catzc.Base.Languages -ParameterFilter { $Config -eq 'javascript' } {
            [Catzc.Base.Languages.JavaScriptConfig]::new([ordered]@{})
        }
    }

    It 'checks every file of the js track, not yet strict, against the declarations in the type root it is given' {
        $config = New-JsConfig -TypeRoot 'C:/widget/node_modules/@types' -RepositoryRoot $script:root | ConvertFrom-Json -AsHashtable
        $config['compilerOptions']['checkJs'] | Should -BeTrue
        $config['compilerOptions']['noEmit'] | Should -BeTrue
        $config['compilerOptions']['strict'] | Should -BeFalse
        @($config['compilerOptions']['typeRoots']) | Should -Be @('C:/widget/node_modules/@types')
        @($config['compilerOptions']['types']) | Should -Be @('node', 'vscode')
        @($config['include']) | Should -Be @('js/**/*.js')
    }

    It 'names no type root when node is not installed, and the dot-prefixed root without a js/ folder' {
        $bare = Join-Path $TestDrive 'bare'
        $null = New-Item -ItemType Directory -Path $bare -Force
        $config = New-JsConfig -TypeRoot '' -RepositoryRoot $bare | ConvertFrom-Json -AsHashtable
        @($config['compilerOptions']['typeRoots']) | Should -HaveCount 0
        @($config['include']) | Should -Be @('.js/**/*.js')
    }
}

Describe 'New-JsConfig — the editor declarations match the manifests' -Tag 'L1', 'integrity' {
    It 'pins @types/vscode to the editor version every extension manifest declares' {
        $engine = [Catzc.Base.VSCode.VscodeOwnExtension]::DefaultEngine
        $engine -match '^\^(?<major>\d+)\.(?<minor>\d+)\.' | Should -BeTrue -Because "the manifests declare a caret engine range ($engine)"
        $declared = "$($Matches['major']).$($Matches['minor'])"
        (Get-ToolConfig -Tool types_vscode).version | Should -Be $declared -Because 'the types must match the editor the extensions run against'
    }
}
