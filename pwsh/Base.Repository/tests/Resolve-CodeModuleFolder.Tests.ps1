Describe 'Resolve-CodeModuleFolder' -Tag 'L0', 'logic', 'DDR-RUNMODE-MODEISDERIVED' {
    BeforeAll {
        $script:originalModulesRoot = $env:CatzcModulesRoot
        $script:originalRepositoryRoot = $env:RepositoryRoot
        $script:originalModulesFolder = $env:CatzcModulesFolder
        $script:repositoryRoot = Join-Path $TestDrive 'widget-repo'
        $script:sourceRoot = Join-Path $script:repositoryRoot 'widget-modules'
        $script:builtRoot = Join-Path $TestDrive 'built/Catzc/6.6.666'
        [System.IO.Directory]::CreateDirectory((Join-Path $script:sourceRoot 'Base.Widget')) | Out-Null
        [System.IO.Directory]::CreateDirectory((Join-Path $script:sourceRoot '.internal')) | Out-Null
        [System.IO.Directory]::CreateDirectory((Join-Path $script:builtRoot 'Catzc.Base.Widget')) | Out-Null
        [System.IO.Directory]::CreateDirectory((Join-Path $script:builtRoot '.internal')) | Out-Null
    }
    AfterAll {
        $env:CatzcModulesRoot = $script:originalModulesRoot
        $env:RepositoryRoot = $script:originalRepositoryRoot
        $env:CatzcModulesFolder = $script:originalModulesFolder
    }
    BeforeEach {
        $env:RepositoryRoot = $script:repositoryRoot
        $env:CatzcModulesFolder = 'widget-modules'
    }

    Context 'the source shape' {
        BeforeEach {
            $env:CatzcModulesRoot = $script:sourceRoot
        }

        It 'finds the bare folder under the code root' {
            Resolve-CodeModuleFolder -Name 'Base.Widget' | Should -Be (Join-Path $script:sourceRoot 'Base.Widget')
        }

        It 'returns nothing when the code root holds no such folder' {
            Resolve-CodeModuleFolder -Name 'Base.Gadget' | Should -BeNullOrEmpty
        }

        It 'returns nothing for a dot folder, which is no module' {
            Resolve-CodeModuleFolder -Name '.internal' | Should -BeNullOrEmpty
        }

        It 'names a code-root folder as it is' {
            Resolve-CodeModuleFolder -BareName 'Base.Widget' | Should -BeExactly 'Base.Widget'
            Resolve-CodeModuleFolder -BareName 'Catzc.Base.Widget' | Should -BeExactly 'Catzc.Base.Widget' -Because 'a source folder carries no namespace to strip'
        }
    }

    Context 'the built shape' {
        BeforeEach {
            $env:CatzcModulesRoot = $script:builtRoot
        }

        It 'finds the namespaced folder for a bare name' {
            Resolve-CodeModuleFolder -Name 'Base.Widget' | Should -Be (Join-Path $script:builtRoot 'Catzc.Base.Widget')
        }

        It 'returns nothing when the code root holds no such folder, or only the bare one' {
            Resolve-CodeModuleFolder -Name 'Base.Gadget' | Should -BeNullOrEmpty
            Resolve-CodeModuleFolder -Name 'Catzc.Base.Widget' | Should -BeNullOrEmpty
        }

        It 'returns nothing for a dot folder, which is no module' {
            Resolve-CodeModuleFolder -Name '.internal' | Should -BeNullOrEmpty
        }

        It 'strips the namespace from a code-root folder, and leaves a bare name and a dot folder alone' {
            Resolve-CodeModuleFolder -BareName 'Catzc.Base.Widget' | Should -BeExactly 'Base.Widget'
            Resolve-CodeModuleFolder -BareName 'Base.Widget' | Should -BeExactly 'Base.Widget'
            Resolve-CodeModuleFolder -BareName '.internal' | Should -BeExactly '.internal'
            Resolve-CodeModuleFolder -BareName 'Catzc.' | Should -BeExactly 'Catzc.'
        }
    }
}
