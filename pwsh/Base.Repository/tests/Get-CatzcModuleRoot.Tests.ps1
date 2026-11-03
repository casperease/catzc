Describe 'Get-CatzcModuleRoot' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:originalModulesRoot = $env:CatzcModulesRoot
        $script:modulesRoot = Join-Path $TestDrive 'modules'
        # The widget module's folder drops the namespace its name carries; the loaded module says where it lives.
        $script:widgetRoot = Join-Path $script:modulesRoot 'Base.Widget'
        [System.IO.Directory]::CreateDirectory($script:widgetRoot) | Out-Null
        $env:CatzcModulesRoot = $script:modulesRoot
    }
    BeforeEach {
        Mock Get-Module -ModuleName Catzc.Base.Repository -ParameterFilter { $Name -ceq 'Catzc.Base.Widget' } -MockWith {
            [pscustomobject]@{ Name = 'Catzc.Base.Widget'; Path = (Join-Path $script:widgetRoot 'Catzc.Base.Widget.psd1'); ModuleBase = $script:widgetRoot }
        }
    }
    AfterAll {
        $env:CatzcModulesRoot = $script:originalModulesRoot
    }

    Context 'explicit -Module' {
        It 'returns the module folder under the code root' {
            Get-CatzcModuleRoot -Module Catzc.Base.Widget |
                Should -Be $script:widgetRoot
        }

        It 'joins -ChildPath below the module folder' {
            $expected = Join-Path $script:widgetRoot 'assets/gadget.txt'
            Get-CatzcModuleRoot 'assets/gadget.txt' -Module Catzc.Base.Widget | Should -Be $expected
        }

        It 'does not require the child path to exist' {
            { Get-CatzcModuleRoot 'configs/missing.yml' -Module Catzc.Base.Widget } | Should -Not -Throw
        }

        It 'throws when no module of that name is loaded' {
            { Get-CatzcModuleRoot -Module Catzc.Base.Gadget } | Should -Throw '*Catzc.Base.Gadget*'
        }
    }

    Context 'a consumer overlay' {
        BeforeAll {
            $script:overlay = Join-Path $TestDrive 'widget-consumer/.catzc/pwsh'
            [System.IO.Directory]::CreateDirectory((Join-Path $overlay 'Base.Widget/assets')) | Out-Null
            [System.IO.Directory]::CreateDirectory((Join-Path $overlay 'Base.Widget/configs')) | Out-Null
            Set-Content -Path (Join-Path $overlay 'Base.Widget/assets/gadget.txt') -Value 'overridden'
            Set-Content -Path (Join-Path $overlay 'Base.Widget/configs/widget.yml') -Value 'limit: 5'
        }
        BeforeEach {
            Mock Get-OverlayRoot -ModuleName Catzc.Base.Repository -MockWith { $overlay }
        }

        It 'returns the overlay''s file for an asset it replaces' {
            Get-CatzcModuleRoot 'assets/gadget.txt' -Module Catzc.Base.Widget |
                Should -Be ([System.IO.Path]::Combine($overlay, 'Base.Widget', 'assets/gadget.txt'))
        }

        It 'returns the bundled path for an asset the overlay does not replace' {
            Get-CatzcModuleRoot 'assets/lever.txt' -Module Catzc.Base.Widget |
                Should -Be (Join-Path $script:widgetRoot 'assets/lever.txt')
        }

        It 'never looks in the overlay outside assets/ (configs merge through Get-Config)' {
            Get-CatzcModuleRoot 'configs/widget.yml' -Module Catzc.Base.Widget |
                Should -Be (Join-Path $script:widgetRoot 'configs/widget.yml')
        }
    }

    Context 'a consumer overlay over a built root' -Tag 'ADR-AUTO-OVERLAY-ASSETOVERRIDE' {
        BeforeAll {
            # The built shape: the code root's module folder carries the namespace, the overlay's stays bare.
            $script:builtRoot = Join-Path $TestDrive 'built'
            $script:builtWidgetRoot = Join-Path $builtRoot 'Catzc.Base.Widget'
            $script:builtOverlay = Join-Path $TestDrive 'gadget-consumer/.catzc/pwsh'
            [System.IO.Directory]::CreateDirectory((Join-Path $builtWidgetRoot 'assets')) | Out-Null
            [System.IO.Directory]::CreateDirectory((Join-Path $builtOverlay 'Base.Widget/assets')) | Out-Null
            Set-Content -Path (Join-Path $builtOverlay 'Base.Widget/assets/gadget.txt') -Value 'overridden'
        }
        BeforeEach {
            $env:CatzcModulesRoot = $script:builtRoot
            Mock Get-CatzcRunMode -ModuleName Catzc.Base.Repository -MockWith { 'build' }
            Mock Get-OverlayRoot -ModuleName Catzc.Base.Repository -MockWith { $builtOverlay }
            Mock Get-Module -ModuleName Catzc.Base.Repository -ParameterFilter { $Name -ceq 'Catzc.Base.Widget' } -MockWith {
                [pscustomobject]@{ Name = 'Catzc.Base.Widget'; Path = (Join-Path $builtWidgetRoot 'Catzc.Base.Widget.psd1'); ModuleBase = $builtWidgetRoot }
            }
        }
        AfterEach {
            $env:CatzcModulesRoot = $script:modulesRoot
        }

        It 'returns the overlay''s bare-folder file for an asset it replaces' {
            Get-CatzcModuleRoot 'assets/gadget.txt' -Module Catzc.Base.Widget |
                Should -Be ([System.IO.Path]::Combine($builtOverlay, 'Base.Widget', 'assets/gadget.txt'))
        }

        It 'returns the namespaced bundled path for an asset the overlay does not replace' {
            Get-CatzcModuleRoot 'assets/lever.txt' -Module Catzc.Base.Widget |
                Should -Be (Join-Path $builtWidgetRoot 'assets/lever.txt')
        }
    }

    Context 'a language module at its track place' {
        BeforeAll {
            $script:placeRepo = Join-Path $TestDrive 'place-repo'
            $script:placeCode = Join-Path $TestDrive 'place-code'
            foreach ($root in $script:placeRepo, $script:placeCode) {
                [System.IO.Directory]::CreateDirectory([System.IO.Path]::Combine($root, 'widgets', 'Widget')) | Out-Null
            }
        }
        BeforeEach {
            Mock Get-RepositoryRoot -ModuleName Catzc.Base.Repository -MockWith { $placeRepo }
            Mock Get-CatzcModulesRoot -ModuleName Catzc.Base.Repository -MockWith { $placeCode }
        }

        It 'resolves under the repository root in source mode' {
            Mock Get-CatzcRunMode -ModuleName Catzc.Base.Repository -MockWith { 'source' }
            Get-CatzcModuleRoot -Place widgets -Module Widget |
                Should -Be ([System.IO.Path]::Combine($script:placeRepo, 'widgets', 'Widget'))
        }

        It 'resolves under the code root in build mode' {
            Mock Get-CatzcRunMode -ModuleName Catzc.Base.Repository -MockWith { 'build' }
            Get-CatzcModuleRoot -Place widgets -Module Widget |
                Should -Be ([System.IO.Path]::Combine($script:placeCode, 'widgets', 'Widget'))
        }

        It 'joins a child path below the folder' {
            Mock Get-CatzcRunMode -ModuleName Catzc.Base.Repository -MockWith { 'build' }
            Get-CatzcModuleRoot 'assets/gadget.txt' -Place widgets -Module Widget |
                Should -Be (Join-Path ([System.IO.Path]::Combine($script:placeCode, 'widgets', 'Widget')) 'assets/gadget.txt')
        }

        It 'throws naming the place, the module and the root when the folder is missing' {
            Mock Get-CatzcRunMode -ModuleName Catzc.Base.Repository -MockWith { 'source' }
            { Get-CatzcModuleRoot -Place widgets -Module Gadget } | Should -Throw "*'Gadget'*'widgets'*place-repo*"
        }
    }

    Context 'default -Module' {
        It 'resolves the calling module when called from module code' {
            $actual = InModuleScope Catzc.Base.Repository { Get-CatzcModuleRoot 'configs/x.yml' }
            $expected = Join-Path (Get-Module Catzc.Base.Repository).ModuleBase 'configs/x.yml'
            $actual | Should -Be $expected
        }

        It 'throws when called from outside a module without -Module' {
            { Get-CatzcModuleRoot 'assets/gadget.txt' } | Should -Throw '*called from outside a module*'
        }
    }
}
