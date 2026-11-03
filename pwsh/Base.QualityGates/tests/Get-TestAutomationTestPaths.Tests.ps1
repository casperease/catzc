Describe 'Get-TestAutomationTestPaths' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:modulesRoot = Join-Path $TestDrive 'repo/pwsh'
        foreach ($folder in 'Widget/tests', 'Gadget/tests', 'Gizmo', '.internal/tests') {
            [void][System.IO.Directory]::CreateDirectory((Join-Path $script:modulesRoot $folder))
        }
        # A module's folder drops the namespace its full name carries.
        function Get-FixtureTests {
            param([string] $Folder)
            [System.IO.Path]::Combine($script:modulesRoot, ($Folder -replace '^Catzc\.', ''), 'tests')
        }
    }

    BeforeEach {
        Mock Get-RepositoryRoot -ModuleName Catzc.Base.QualityGates { Join-Path $TestDrive 'repo' }
        Mock Get-ModuleOrder -ModuleName Catzc.Base.QualityGates { @('Catzc.Widget', 'Catzc.Gizmo', 'Catzc.Gadget') }
        Mock Get-LanguageTestFolders -ModuleName Catzc.Base.QualityGates {}
        Mock Get-CatzcRunMode -ModuleName Catzc.Base.QualityGates { 'source' }
    }

    Context 'in build mode' {
        BeforeAll {
            $script:bundleTests = Join-Path $TestDrive 'bundle/Base.Widget/tests'
            $script:consumerTests = Join-Path $TestDrive 'repo/widget/Local/tests'
            $script:overlayTests = Join-Path $TestDrive 'repo/.catzc/pwsh/Gizmo/tests'
            foreach ($folder in $script:bundleTests, $script:consumerTests, $script:overlayTests, (Join-Path $TestDrive 'repo/widget/Bare')) {
                [void][System.IO.Directory]::CreateDirectory($folder)
            }
        }

        BeforeEach {
            Mock Get-CatzcRunMode -ModuleName Catzc.Base.QualityGates { 'build' }
            Mock Get-Track -ModuleName Catzc.Base.QualityGates {
                $engine = [pscustomobject]@{ name = 'pwsh'; type = 'modules'; places = @('bundle') }
                $engine | Add-Member -MemberType ScriptMethod -Name FullNameOf -Value { param($Folder) "Catzc.$Folder" }
                $engine
                $consumer = [pscustomobject]@{ name = 'widget'; type = 'modules'; places = @('widget') }
                $consumer | Add-Member -MemberType ScriptMethod -Name FullNameOf -Value { param($Folder) "Widget.$Folder" }
                $consumer
                [pscustomobject]@{ name = 'docs'; type = 'documentation'; places = @('widget') }
            }
            Mock Get-Track -ModuleName Catzc.Base.QualityGates -ParameterFilter { $Name -eq 'pwsh' } {
                $engine = [pscustomobject]@{ name = 'pwsh'; places = @('bundle') }
                $engine | Add-Member -MemberType ScriptMethod -Name FullNameOf -Value { param($Folder) "Catzc.$Folder" }
                $engine
            }
            Mock Get-OverlayRoot -ModuleName Catzc.Base.QualityGates { Join-Path $TestDrive 'repo/.catzc/pwsh' }
        }

        It 'lists the consumer tracks'' tests folders and the overlay tests, and never the bundle''s own' {
            $paths = @(InModuleScope Catzc.Base.QualityGates { Get-TestAutomationTestPaths })
            $paths | Should -Be @($script:overlayTests, $script:consumerTests)
            $paths | Should -Not -Contain $script:bundleTests
            Should -Invoke Get-LanguageTestFolders -ModuleName Catzc.Base.QualityGates -Times 0 -Exactly
        }

        It 'narrows to the named modules' {
            $paths = @(InModuleScope Catzc.Base.QualityGates { Get-TestAutomationTestPaths -Modules 'Widget.Local' })
            $paths | Should -Be @($script:consumerTests)
        }

        It 'lists no overlay tests when the root has no overlay' {
            Mock Get-OverlayRoot -ModuleName Catzc.Base.QualityGates {}
            $paths = @(InModuleScope Catzc.Base.QualityGates { Get-TestAutomationTestPaths })
            $paths | Should -Be @($script:consumerTests)
        }
    }

    Context 'with language test folders' {
        BeforeAll {
            $script:widgetGo = Join-Path $TestDrive 'repo/go/tests/catzc-widget'
            $script:gizmoGo = Join-Path $TestDrive 'repo/go/tests/catzc-gizmo'
            $script:widgetPython = Join-Path $TestDrive 'repo/python/tests/catzc-widget'
        }

        BeforeEach {
            Mock Get-LanguageTestFolders -ModuleName Catzc.Base.QualityGates {
                [pscustomobject]@{ Language = 'go'; Module = 'Catzc.Gizmo'; Folder = $script:gizmoGo; Name = 'catzc-gizmo' }
                [pscustomobject]@{ Language = 'go'; Module = 'Catzc.Widget'; Folder = $script:widgetGo; Name = 'catzc-widget' }
                [pscustomobject]@{ Language = 'python'; Module = 'Catzc.Widget'; Folder = $script:widgetPython; Name = 'catzc-widget' }
            }
        }

        It 'puts a module''s language test folders after its tests folder, and includes a module with only those' {
            $paths = @(InModuleScope Catzc.Base.QualityGates { Get-TestAutomationTestPaths })
            $paths | Should -Be @((Get-FixtureTests 'Catzc.Widget'), $script:widgetGo, $script:widgetPython,
                $script:gizmoGo, (Get-FixtureTests 'Catzc.Gadget'), (Get-FixtureTests '.internal'))
        }

        It 'narrows the language test folders to the named modules' {
            $paths = @(InModuleScope Catzc.Base.QualityGates { Get-TestAutomationTestPaths -Modules 'Catzc.Gizmo', 'Catzc.Gadget' })
            $paths | Should -Be @($script:gizmoGo, (Get-FixtureTests 'Catzc.Gadget'))
        }

        It 'keeps the language test folders with their modules in the ordinal fallback order' {
            Mock Get-ModuleOrder -ModuleName Catzc.Base.QualityGates { throw 'Cycle in the widget graph' }
            $paths = @(InModuleScope Catzc.Base.QualityGates { Get-TestAutomationTestPaths })
            $paths | Should -Be @((Get-FixtureTests 'Catzc.Gadget'), $script:gizmoGo, (Get-FixtureTests 'Catzc.Widget'),
                $script:widgetGo, $script:widgetPython, (Get-FixtureTests '.internal'))
        }

        It 'throws when a test folder matches no catzc module' {
            Mock Get-LanguageTestFolders -ModuleName Catzc.Base.QualityGates { throw 'Test folder(s) matching no catzc module: python/tests/catzc-sprocket/.' }
            { InModuleScope Catzc.Base.QualityGates { Get-TestAutomationTestPaths } } |
                Should -Throw '*python/tests/catzc-sprocket/*'
        }
    }

    It 'returns the existing tests folders in dependency order, dot-prefixed infrastructure last' {
        $paths = @(InModuleScope Catzc.Base.QualityGates { Get-TestAutomationTestPaths })
        $paths | Should -Be @((Get-FixtureTests 'Catzc.Widget'), (Get-FixtureTests 'Catzc.Gadget'),
            (Get-FixtureTests '.internal'))
    }

    It 'falls back to the ordinal module order when the dependency order cannot be computed' {
        Mock Get-ModuleOrder -ModuleName Catzc.Base.QualityGates { throw 'Cycle in the widget graph' }
        $paths = @(InModuleScope Catzc.Base.QualityGates { Get-TestAutomationTestPaths })
        $paths | Should -Be @((Get-FixtureTests 'Catzc.Gadget'), (Get-FixtureTests 'Catzc.Widget'),
            (Get-FixtureTests '.internal'))
    }

    It 'narrows to the named modules and drops infrastructure when filtered' {
        $paths = @(InModuleScope Catzc.Base.QualityGates { Get-TestAutomationTestPaths -Modules 'Catzc.Gadget' })
        $paths | Should -Be @((Get-FixtureTests 'Catzc.Gadget'))
    }

    It 'matches a named full module name to the module''s own tests folder, whose folder drops the namespace' {
        $paths = @(InModuleScope Catzc.Base.QualityGates { Get-TestAutomationTestPaths -Modules 'Catzc.Widget' })
        $paths | Should -Be @((Get-FixtureTests 'Catzc.Widget'))
    }

    It 'does not match a named folder name without the namespace' {
        @(InModuleScope Catzc.Base.QualityGates { Get-TestAutomationTestPaths -Modules 'Widget' }) | Should -HaveCount 0
    }

    It 'returns nothing when no named module has a tests folder' {
        @(InModuleScope Catzc.Base.QualityGates { Get-TestAutomationTestPaths -Modules 'Catzc.Gizmo' }) |
            Should -HaveCount 0
    }
}
