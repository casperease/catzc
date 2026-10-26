Describe 'New-JsConfig' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:root = Join-Path $TestDrive 'repo'
        $null = New-Item -ItemType Directory -Path (Join-Path $script:root 'js/catzc-widget') -Force
        Mock Get-Config -ModuleName Catzc.Base.Languages -ParameterFilter { $Config -eq 'javascript' } {
            [Catzc.Base.Languages.JavaScriptConfig]::new([ordered]@{})
        }
    }

    It 'checks every file of the js track, not yet strict, against the declarations in the type root it is given' {
        $config = New-JsConfig -TypeRoot 'C:/widget/node_modules/@types' -RepositoryRoot $script:root |
            ConvertFrom-Json -AsHashtable
        $config['compilerOptions']['checkJs'] | Should -BeTrue
        $config['compilerOptions']['noEmit'] | Should -BeTrue
        $config['compilerOptions']['strict'] | Should -BeFalse
        @($config['compilerOptions']['typeRoots']) | Should -Be @('C:/widget/node_modules/@types')
        @($config['compilerOptions']['types']) | Should -Be @('node', 'vscode')
        # node's own resolution, never the deprecated node10 the classic 'node' value or a bare commonjs module implies.
        $config['compilerOptions']['module'] | Should -Be 'node16'
        $config['compilerOptions']['moduleResolution'] | Should -Be 'node16'
        @($config['include']) | Should -Be @('js/**/*.js')
    }

    It 'leaves the raised modules out of the lenient project and checks only them, strictly, in the strict one' {
        Mock Get-Config -ModuleName Catzc.Base.Languages -ParameterFilter { $Config -eq 'javascript' } {
            [Catzc.Base.Languages.JavaScriptConfig]::new([ordered]@{ strict = @('catzc-widget', 'catzc-gadget') })
        }
        $lenient = New-JsConfig -TypeRoot 'C:/types' -RepositoryRoot $script:root | ConvertFrom-Json -AsHashtable
        @($lenient['exclude']) | Should -Be @('js/catzc-widget/**/*.js', 'js/catzc-gadget/**/*.js')
        $strict = New-JsConfig -Target jsconfig.strict.json -RepositoryRoot $script:root | ConvertFrom-Json -AsHashtable
        $strict['extends'] | Should -Be './jsconfig.json'
        $strict['compilerOptions']['strict'] | Should -BeTrue
        @($strict['include']) | Should -Be @('js/catzc-widget/**/*.js', 'js/catzc-gadget/**/*.js')
        @($strict['exclude']) | Should -HaveCount 0
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
        $engine -match '^\^(?<major>\d+)\.(?<minor>\d+)\.' |
            Should -BeTrue -Because "the manifests declare a caret engine range ($engine)"
        $declared = "$($Matches['major']).$($Matches['minor'])"
        (Get-ToolConfig -Tool types_vscode).version |
            Should -Be $declared -Because 'the types must match the editor the extensions run against'
    }
}
