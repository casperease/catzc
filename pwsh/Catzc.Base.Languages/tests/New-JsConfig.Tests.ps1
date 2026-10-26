Describe 'New-JsConfig' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:root = Join-Path $TestDrive 'repo'
        $null = New-Item -ItemType Directory -Path (Join-Path $script:root 'js/catzc-widget') -Force
        $script:strict = @()
        Mock Get-Config -ModuleName Catzc.Base.Languages -ParameterFilter { $Config -eq 'javascript' } {
            [Catzc.Base.Languages.JavaScriptConfig]::new([ordered]@{ strict = @($script:strict) })
        }
        $script:render = { param([string] $Target = 'jsconfig.json') New-JsConfig -Target $Target -RepositoryRoot $script:root }
    }

    BeforeEach {
        $script:strict = @()
    }

    It 'gives the editor''s project every file of the js track, leniently, while no module is raised, and the lenient one nothing' {
        $config = & $script:render | ConvertFrom-Json -AsHashtable
        $config['compilerOptions']['checkJs'] | Should -BeTrue
        $config['compilerOptions']['noEmit'] | Should -BeTrue
        $config['compilerOptions']['strict'] | Should -BeFalse
        @($config['compilerOptions']['types']) | Should -Be @('node', 'vscode')
        # node's own resolution, never the deprecated node10 the classic 'node' value or a bare commonjs module implies.
        $config['compilerOptions']['module'] | Should -Be 'node16'
        $config['compilerOptions']['moduleResolution'] | Should -Be 'node16'
        @($config['include']) | Should -Be @('js/**/*.js')
        @((& $script:render 'jsconfig.lenient.json' | ConvertFrom-Json -AsHashtable)['include']) | Should -HaveCount 0
    }

    It 'gives the editor''s project the raised modules, strictly, and the lenient one every other module' {
        $script:strict = @('catzc-widget', 'catzc-gadget')
        $editor = & $script:render | ConvertFrom-Json -AsHashtable
        $editor['compilerOptions']['strict'] | Should -BeTrue
        @($editor['include']) | Should -Be @('js/catzc-widget/**/*.js', 'js/catzc-gadget/**/*.js')
        $editor.Keys | Should -Not -Contain 'exclude'
        $lenient = & $script:render 'jsconfig.lenient.json' | ConvertFrom-Json -AsHashtable
        $lenient['extends'] | Should -Be './jsconfig.json'
        $lenient['compilerOptions']['strict'] | Should -BeFalse
        @($lenient['include']) | Should -Be @('js/**/*.js')
        @($lenient['exclude']) | Should -Be @('js/catzc-widget/**/*.js', 'js/catzc-gadget/**/*.js')
    }

    It 'names its type root relatively, the folder javascript.yml declares, with no machine or user path in either file' {
        $editor = & $script:render
        @(($editor | ConvertFrom-Json -AsHashtable)['compilerOptions']['typeRoots']) |
            Should -Be @("./$([Catzc.Base.Languages.JavaScriptConfig]::DefaultTypesFolder)/node_modules/@types")
        foreach ($text in $editor, (& $script:render 'jsconfig.lenient.json')) {
            $text | Should -Not -Match '[A-Za-z]:[\\/]' -Because 'a drive letter is a machine path'
            $text | Should -Not -Match '(?i)[\\/]users[\\/]|[\\/]home[\\/]' -Because 'a user folder is a user path'
        }
    }

    It 'renders the dot-prefixed root without a js/ folder' {
        $bare = Join-Path $TestDrive 'bare'
        $null = New-Item -ItemType Directory -Path $bare -Force
        @((New-JsConfig -RepositoryRoot $bare | ConvertFrom-Json -AsHashtable)['include']) | Should -Be @('.js/**/*.js')
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

    It 'reads the declarations'' versions from the folder javascript.yml declares, the one folder they are installed into' {
        $folder = (Get-Config -Config javascript).types_folder
        foreach ($tool in 'types_node', 'types_vscode') {
            (Get-ToolConfig -Tool $tool).version_command | Should -BeLike "*--prefix $folder *" -Because "$tool's version is read where it is installed"
        }
    }
}
