Describe 'Get-CatzcModuleRoot' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:originalModulesRoot = $env:CatzcModulesRoot
        $script:modulesRoot = Join-Path $TestDrive 'modules'
        [System.IO.Directory]::CreateDirectory((Join-Path $script:modulesRoot 'Catzc.Base.Widget')) | Out-Null
        [System.IO.Directory]::CreateDirectory((Join-Path $script:modulesRoot 'Catzc.Base.Repository')) | Out-Null
        $env:CatzcModulesRoot = $script:modulesRoot
    }
    AfterAll {
        $env:CatzcModulesRoot = $script:originalModulesRoot
    }

    Context 'explicit -Module' {
        It 'returns the module folder under the code root' {
            Get-CatzcModuleRoot -Module Catzc.Base.Widget | Should -Be (Join-Path $script:modulesRoot 'Catzc.Base.Widget')
        }

        It 'joins -ChildPath below the module folder' {
            $expected = Join-Path (Join-Path $script:modulesRoot 'Catzc.Base.Widget') 'assets/gadget.txt'
            Get-CatzcModuleRoot 'assets/gadget.txt' -Module Catzc.Base.Widget | Should -Be $expected
        }

        It 'does not require the child path to exist' {
            { Get-CatzcModuleRoot 'configs/missing.yml' -Module Catzc.Base.Widget } | Should -Not -Throw
        }

        It 'throws when the module folder does not exist under the code root' {
            { Get-CatzcModuleRoot -Module Catzc.Base.Gadget } | Should -Throw '*Catzc.Base.Gadget*'
        }
    }

    Context 'default -Module' {
        It 'resolves the calling module when called from module code' {
            $actual = InModuleScope Catzc.Base.Repository { Get-CatzcModuleRoot 'configs/x.yml' }
            $expected = Join-Path (Join-Path $script:modulesRoot 'Catzc.Base.Repository') 'configs/x.yml'
            $actual | Should -Be $expected
        }

        It 'throws when called from outside a module without -Module' {
            { Get-CatzcModuleRoot 'assets/gadget.txt' } | Should -Throw '*called from outside a module*'
        }
    }
}
