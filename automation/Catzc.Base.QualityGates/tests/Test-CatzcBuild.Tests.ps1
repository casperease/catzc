<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/tests/Test-CatzcBuild.Tests.ps1
    kind: pester-test
    adrs:
      - ADR-AUTO-TEST#30
---
#>

Describe 'Test-CatzcBuild' -Tag 'L0', 'logic', 'ADR-AUTO-TEST#30' {
    BeforeAll {
        # Build-Modules (Catzc.Base.Exporter) is the boundary: mocked here, so this test file proves the wiring...
        # [comment:1](/docs/references/automation/catzc-base-qualitygates/tests/Test-CatzcBuild.Tests.ps1.md#comment1)
        $script:harness = 'Catzc.Base.QualityGates'
    }

    BeforeEach {
        $script:destinations = [System.Collections.Generic.List[string]]::new()
        Mock Assert-SourceTree -ModuleName Catzc.Base.QualityGates { }
        Mock Write-Message -ModuleName Catzc.Base.QualityGates { }
        Mock Build-Modules -ModuleName Catzc.Base.QualityGates -ParameterFilter { $DryRun } {
            [pscustomobject]@{ Modules = @('Catzc.Widget', 'Catzc.Gadget'); DryRun = $true }
        }
        Mock Build-Modules -ModuleName Catzc.Base.QualityGates -ParameterFilter { -not $DryRun } {
            # A real (temp) build root holding the entry script, so the existence assert and the cleanup run for real.
            $buildRoot = Join-Path $Destination 'Catzc/6.6.666'
            [void][System.IO.Directory]::CreateDirectory($buildRoot)
            [System.IO.File]::WriteAllText((Join-Path $buildRoot 'Import-Catzc.ps1'), '# entry')
            $script:destinations.Add($Destination)
            [pscustomobject]@{ BuildRoot = $buildRoot; Version = '6.6.666'; Modules = @($PSBoundParameters['Module']); DryRun = $false }
        }
        Mock Invoke-TestRun -ModuleName Catzc.Base.QualityGates {
            [pscustomobject]@{ Result = 'Passed'; ExcludedTests = @() }
        }
    }

    It 'fails fast outside the source tree, before building anything' {
        Mock Assert-SourceTree -ModuleName Catzc.Base.QualityGates { throw 'not the source tree' }

        { Test-CatzcBuild } | Should -Throw '*not the source tree*'
        Should -Invoke Build-Modules -ModuleName Catzc.Base.QualityGates -Times 0
    }

    It 'resolves the selection with a dry run, then builds it with the full vendor policy into a fresh temp folder' {
        Test-CatzcBuild -Module 'Catzc.Widget'

        Should -Invoke Build-Modules -ModuleName Catzc.Base.QualityGates -Times 1 -ParameterFilter {
            $DryRun -and $VendorPolicy -eq 'full' -and $Module -contains 'Catzc.Widget'
        }
        Should -Invoke Build-Modules -ModuleName Catzc.Base.QualityGates -Times 1 -ParameterFilter {
            -not $DryRun -and $VendorPolicy -eq 'full' -and $Destination -like "$([System.IO.Path]::GetTempPath())*"
        }
    }

    It 'adds the harness module to the build when the selection lacks it' {
        Test-CatzcBuild -Module 'Catzc.Widget'

        Should -Invoke Build-Modules -ModuleName Catzc.Base.QualityGates -Times 1 -ParameterFilter {
            -not $DryRun -and ($Module -join ',') -eq "Catzc.Widget,Catzc.Gadget,$script:harness"
        }
    }

    It 'passes the selection through unchanged when it already contains the harness module' {
        Mock Build-Modules -ModuleName Catzc.Base.QualityGates -ParameterFilter { $DryRun } {
            [pscustomobject]@{ Modules = @('Catzc.Widget', $script:harness); DryRun = $true }
        }

        Test-CatzcBuild -ModuleProfile 'gadgets'

        Should -Invoke Build-Modules -ModuleName Catzc.Base.QualityGates -Times 1 -ParameterFilter {
            -not $DryRun -and $ModuleProfile -eq 'gadgets' -and -not $PSBoundParameters.ContainsKey('Module')
        }
    }

    It 'runs the shared harness on the resolved modules with the build entry script and source-only excluded' {
        Test-CatzcBuild -Module 'Catzc.Widget' -MinLevel 1 -Level 1 -Category Logic

        Should -Invoke Invoke-TestRun -ModuleName Catzc.Base.QualityGates -Times 1 -ParameterFilter {
            $EntryPoint -eq 'Test-CatzcBuild' -and
            ($Modules -join ',') -eq 'Catzc.Widget,Catzc.Gadget' -and
            $OptOutTag -contains 'source-only' -and
            $EntryScript -like '*Catzc*6.6.666*Import-Catzc.ps1' -and
            $EntryParameter['RepositoryRoot'] -eq (Get-RepositoryRoot) -and
            $MinLevel -eq 1 -and $MaxLevel -eq 1 -and $Category -eq 'Logic'
        }
    }

    It 'asks for every tier the location allows (L3 runs in place only), both categories' {
        Test-CatzcBuild

        Should -Invoke Invoke-TestRun -ModuleName Catzc.Base.QualityGates -Times 1 -ParameterFilter {
            $MinLevel -eq 0 -and $MaxLevel -eq 3 -and $Category -eq 'Both'
        }
    }

    It 'deletes the build when the run ends, passed or failed' {
        Test-CatzcBuild
        Mock Invoke-TestRun -ModuleName Catzc.Base.QualityGates { throw 'Test-CatzcBuild failed: 1 failed' }
        { Test-CatzcBuild } | Should -Throw '*1 failed*'

        $script:destinations | Should -HaveCount 2
        foreach ($destination in $script:destinations) {
            $destination | Should -Not -Exist
        }
    }

    It 'returns the run summary with the build attached under -PassThru' {
        $summary = Test-CatzcBuild -PassThru

        $summary.Result | Should -Be 'Passed'
        $summary.Build.Version | Should -Be '6.6.666'
    }

    It 'rejects a minimum tier above the maximum' {
        { Test-CatzcBuild -MinLevel 2 -MaxLevel 1 } | Should -Throw '*cannot exceed*'
    }
}
