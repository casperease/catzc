<#
---
catzc:
  immutable:
    path: automation/Catzc.Base.QualityGates/tests/Get-TestAutomationTestPaths.Tests.ps1
    folder: tests
    name: get-test-automation-test-paths-tests
    filetype: ps1
    kind: test
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.QualityGates
    moduletype: pwsh-folder
    catzc_bundle: azure
  edges:
    page: docs/references/automation/catzc-base-qualitygates/tests/Get-TestAutomationTestPaths.Tests.ps1.md
    cites:
      - ADR-AUTO-TEST#3
---
#>

Describe 'Get-TestAutomationTestPaths' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:automation = Join-Path $TestDrive 'repo/automation'
        foreach ($folder in 'Catzc.Widget/tests', 'Catzc.Gadget/tests', 'Catzc.Gizmo', '.internal/tests') {
            [void][System.IO.Directory]::CreateDirectory((Join-Path $script:automation $folder))
        }
        function Get-FixtureTests {
            param([string] $Folder)
            [System.IO.Path]::Combine($script:automation, $Folder, 'tests')
        }
    }

    BeforeEach {
        Mock Get-RepositoryRoot -ModuleName Catzc.Base.QualityGates { Join-Path $TestDrive 'repo' }
        Mock Get-ModuleOrder -ModuleName Catzc.Base.QualityGates { @('Catzc.Widget', 'Catzc.Gizmo', 'Catzc.Gadget') }
        Mock Get-LanguageTestFolders -ModuleName Catzc.Base.QualityGates {}
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
            $paths | Should -Be @((Get-FixtureTests 'Catzc.Widget'), $script:widgetGo, $script:widgetPython, $script:gizmoGo, (Get-FixtureTests 'Catzc.Gadget'), (Get-FixtureTests '.internal'))
        }

        It 'narrows the language test folders to the named modules' {
            $paths = @(InModuleScope Catzc.Base.QualityGates { Get-TestAutomationTestPaths -Modules 'Catzc.Gizmo', 'Catzc.Gadget' })
            $paths | Should -Be @($script:gizmoGo, (Get-FixtureTests 'Catzc.Gadget'))
        }

        It 'keeps the language test folders with their modules in the ordinal fallback order' {
            Mock Get-ModuleOrder -ModuleName Catzc.Base.QualityGates { throw 'Cycle in the widget graph' }
            $paths = @(InModuleScope Catzc.Base.QualityGates { Get-TestAutomationTestPaths })
            $paths | Should -Be @((Get-FixtureTests 'Catzc.Gadget'), $script:gizmoGo, (Get-FixtureTests 'Catzc.Widget'), $script:widgetGo, $script:widgetPython, (Get-FixtureTests '.internal'))
        }

        It 'throws when a test folder matches no catzc module' {
            Mock Get-LanguageTestFolders -ModuleName Catzc.Base.QualityGates { throw 'Test folder(s) matching no catzc module: python/tests/catzc-sprocket/.' }
            { InModuleScope Catzc.Base.QualityGates { Get-TestAutomationTestPaths } } | Should -Throw '*python/tests/catzc-sprocket/*'
        }
    }

    It 'returns the existing tests folders in dependency order, dot-prefixed infrastructure last' {
        $paths = @(InModuleScope Catzc.Base.QualityGates { Get-TestAutomationTestPaths })
        $paths | Should -Be @((Get-FixtureTests 'Catzc.Widget'), (Get-FixtureTests 'Catzc.Gadget'), (Get-FixtureTests '.internal'))
    }

    It 'falls back to the ordinal module order when the dependency order cannot be computed' {
        Mock Get-ModuleOrder -ModuleName Catzc.Base.QualityGates { throw 'Cycle in the widget graph' }
        $paths = @(InModuleScope Catzc.Base.QualityGates { Get-TestAutomationTestPaths })
        $paths | Should -Be @((Get-FixtureTests 'Catzc.Gadget'), (Get-FixtureTests 'Catzc.Widget'), (Get-FixtureTests '.internal'))
    }

    It 'narrows to the named modules and drops infrastructure when filtered' {
        $paths = @(InModuleScope Catzc.Base.QualityGates { Get-TestAutomationTestPaths -Modules 'Catzc.Gadget' })
        $paths | Should -Be @((Get-FixtureTests 'Catzc.Gadget'))
    }

    It 'returns nothing when no named module has a tests folder' {
        @(InModuleScope Catzc.Base.QualityGates { Get-TestAutomationTestPaths -Modules 'Catzc.Gizmo' }) | Should -HaveCount 0
    }
}
