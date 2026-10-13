# Get-TestAutomationTestPaths over a fixture automation tree in $TestDrive (Get-RepositoryRoot and
# Get-ModuleTestOrder mocked): two modules with tests, one without, and one dot-prefixed infrastructure folder.
# Neutral fixture names ([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
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
        Mock Get-ModuleTestOrder -ModuleName Catzc.Base.QualityGates { @('Catzc.Widget', 'Catzc.Gizmo', 'Catzc.Gadget') }
    }

    It 'returns the existing tests folders in dependency order, dot-prefixed infrastructure last' {
        $paths = @(InModuleScope Catzc.Base.QualityGates { Get-TestAutomationTestPaths })
        $paths | Should -Be @((Get-FixtureTests 'Catzc.Widget'), (Get-FixtureTests 'Catzc.Gadget'), (Get-FixtureTests '.internal'))
    }

    It 'falls back to the ordinal module order when the dependency order cannot be computed' {
        Mock Get-ModuleTestOrder -ModuleName Catzc.Base.QualityGates { throw 'Cycle in the widget graph' }
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
