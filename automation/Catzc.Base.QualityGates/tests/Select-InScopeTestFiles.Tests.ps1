Describe 'Select-InScopeTestFiles' -Tag 'L0', 'logic' {
    BeforeAll {
        # Fake discovery tests — the Pester test shape Get-TestBlockTag walks.
        $script:root = [pscustomobject]@{ IsRoot = $true; Tag = @(); Parent = $null }
        function New-FakeTest {
            param([string] $File, [string] $Name, [string[]] $BlockTags)
            [pscustomobject]@{
                Tag          = @()
                Block        = [pscustomobject]@{ IsRoot = $false; Tag = @($BlockTags); Parent = $script:root }
                ExpandedPath = $Name
                ScriptBlock  = [pscustomobject]@{ File = $File }
            }
        }
        function Select-Scope {
            param($Tests, [string[]] $ExcludeTag, [string[]] $TestFiles)
            InModuleScope Catzc.Base.QualityGates -Parameters @{ D = [pscustomobject]@{ Tests = @($Tests) }; X = $ExcludeTag; F = $TestFiles } {
                param($D, $X, $F)
                Select-InScopeTestFiles -Discovery $D -ExcludeTag $X -TestFiles $F
            }
        }

        $script:widget = 'C:\repo\automation\Widget\tests\Get-Widget.Tests.ps1'
        $script:gadget = 'C:\repo\automation\Gadget\tests\Get-Gadget.Tests.ps1'
        $script:tests = @(
            (New-FakeTest $script:widget 'Widget.logic' @('L0', 'logic'))
            (New-FakeTest $script:widget 'Widget.real environment' @('L3', 'logic'))
            (New-FakeTest $script:gadget 'Gadget.logic' @('L0', 'logic'))
            (New-FakeTest $script:gadget 'Gadget.integrity' @('L1', 'integrity'))
        )
    }

    It 'keeps every file when the run excludes nothing, and drops no test' {
        $result = Select-Scope $script:tests @() @($script:widget, $script:gadget)
        $result.Files | Should -Be @($script:widget, $script:gadget)
        @($result.OutOfScopeTests).Count | Should -Be 0
    }

    It 'keeps only the files holding an in-scope test, and returns every test of the dropped ones' {
        $result = Select-Scope $script:tests @('L0', 'L1', 'L2') @($script:widget, $script:gadget)
        $result.Files | Should -Be @($script:widget)
        @($result.OutOfScopeTests.ExpandedPath) | Should -Be @('Gadget.logic', 'Gadget.integrity')
    }

    It 'keeps a file holding one in-scope test among out-of-scope ones whole' {
        $result = Select-Scope $script:tests @('L0', 'L1', 'L2') @($script:widget)
        $result.Files | Should -Be @($script:widget)
        @($result.OutOfScopeTests).Count | Should -Be 0
    }

    It 'filters by category too' {
        $result = Select-Scope $script:tests @('logic') @($script:widget, $script:gadget)
        $result.Files | Should -Be @($script:gadget)
        @($result.OutOfScopeTests.ExpandedPath) | Should -Be @('Widget.logic', 'Widget.real environment')
    }

    It 'keeps a file discovery found no test in, so its worker still reports why' {
        $broken = 'C:\repo\automation\Gizmo\tests\Get-Gizmo.Tests.ps1'
        $result = Select-Scope $script:tests @('L0', 'L1', 'L2') @($script:gadget, $broken)
        $result.Files | Should -Be @($broken)
        @($result.OutOfScopeTests.ExpandedPath) | Should -Be @('Gadget.logic', 'Gadget.integrity')
    }

    It 'keeps the run order and ignores tests outside the given files' {
        $result = Select-Scope $script:tests @() @($script:gadget)
        $result.Files | Should -Be @($script:gadget)
    }

    It 'returns nothing to run when no file holds an in-scope test' {
        $result = Select-Scope $script:tests @('L0', 'L1', 'L2', 'L3') @($script:widget, $script:gadget)
        @($result.Files).Count | Should -Be 0
        @($result.OutOfScopeTests).Count | Should -Be 4
    }
}
