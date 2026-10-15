<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/tests/Test-InIsolation.Tests.ps1
    kind: pester-test
    adrs:
      - ADR-AUTO-ASSETDEP#3
---
#>

Describe 'Test-InIsolation' -Tag 'L0', 'logic' {
    BeforeAll {
        Mock Get-Config -ModuleName Catzc.Base.QualityGates {
            [pscustomobject]@{ profiles = [ordered]@{ minimal = @('Catzc.Base.Asserts') } }
        }
        Mock Get-ModuleProfile -ModuleName Catzc.Base.QualityGates {
            @('Catzc.Base.Asserts', '.vendor', '.internal', '.compiled')
        }
        Mock Write-Message -ModuleName Catzc.Base.QualityGates { }
        # Copy-Automation is mocked to fabricate a tests/ folder in the sandbox so there is something to run.
        Mock Copy-Automation -ModuleName Catzc.Base.QualityGates {
            [System.IO.Directory]::CreateDirectory((Join-Path $Destination 'automation/Catzc.Base.Asserts/tests')) | Out-Null
        }
    }

    It 'Process mode launches a child pwsh runner and reports success on exit 0' {
        Mock Invoke-Executable -ModuleName Catzc.Base.QualityGates { [pscustomobject]@{ ExitCode = 0 } }
        $result = Test-InIsolation -ModuleProfile minimal -PassThru
        $result.Isolation | Should -Be 'Process'
        $result.Success | Should -BeTrue
        Should -Invoke Invoke-Executable -ModuleName Catzc.Base.QualityGates -ParameterFilter {
            $Command -match 'pwsh -NoProfile -File'
        }
    }

    It 'reports failure when the child exits non-zero' {
        Mock Invoke-Executable -ModuleName Catzc.Base.QualityGates { [pscustomobject]@{ ExitCode = 3 } }
        $result = Test-InIsolation -ModuleProfile minimal -PassThru
        $result.Success | Should -BeFalse
        $result.Failed | Should -Be 3
    }

    It 'the generated runner uses the optimized initializer and excludes integrity (Category Logic default)' {
        Mock Invoke-Executable -ModuleName Catzc.Base.QualityGates { [pscustomobject]@{ ExitCode = 0 } }
        $dest = Join-Path $TestDrive ([guid]::NewGuid())
        Test-InIsolation -ModuleProfile minimal -Destination $dest -KeepSandbox | Out-Null
        $runner = Get-Content (Join-Path $dest '.isolation-run.ps1') -Raw
        $runner | Should -Match 'importer\.ps1'
        $runner | Should -Match '-SkipJanitors'
        $runner | Should -Match "'integrity'"
    }

    It 'InProcess mode runs Pester in-session and restores $env:RepositoryRoot' {
        Mock Invoke-Executable -ModuleName Catzc.Base.QualityGates { [pscustomobject]@{ ExitCode = 0 } }
        Mock Invoke-Pester -ModuleName Catzc.Base.QualityGates {
            [pscustomobject]@{ TotalCount = 5; FailedCount = 0 }
        }
        $before = $env:RepositoryRoot
        $result = Test-InIsolation -ModuleProfile minimal -Isolation InProcess -PassThru
        $result.Isolation | Should -Be 'InProcess'
        $result.Total | Should -Be 5
        $result.Success | Should -BeTrue
        $env:RepositoryRoot | Should -Be $before
        Should -Invoke Invoke-Executable -ModuleName Catzc.Base.QualityGates -Times 0
    }

    It 'throws on an unknown profile name (ValidateScript)' {
        { Test-InIsolation -ModuleProfile nope } | Should -Throw
    }
}

# The real-asset test of for Test-InIsolation's lazy Pester load: the vendored Pester under the code root.
# [comment:1](/docs/references/automation/catzc-base-qualitygates/tests/Test-InIsolation.Tests.ps1.md#comment1)
Describe 'Test-InIsolation (vendored Pester)' -Tag 'L1', 'integrity', 'ADR-AUTO-ASSETDEP#3' {
    BeforeAll {
        Mock Get-Module -ModuleName Catzc.Base.QualityGates -ParameterFilter { $Name -eq 'Pester' } { }
        # -PassThru answers with the module, as the real import does: the already-running Pester
        Mock Import-Module -ModuleName Catzc.Base.QualityGates -ParameterFilter { "$Name" -like '*Pester*' } { Get-Module Pester }
        Mock Get-ModuleProfile -ModuleName Catzc.Base.QualityGates { throw 'stop after the Pester import' }
    }

    It 'lazy-loads the vendored Pester from the code root, a real module matching the running Pester' {
        { Test-InIsolation -Modules 'Catzc.Base.Asserts' } | Should -Throw '*stop after the Pester import*'

        $expected = Join-Path (Get-CatzcModulesRoot) '.vendor/Pester'
        Should -Invoke Import-Module -ModuleName Catzc.Base.QualityGates -Times 1 -Exactly -ParameterFilter {
            "$Name" -eq $expected
        }

        $manifests = @([System.IO.Directory]::GetFiles($expected, 'Pester.psd1', [System.IO.SearchOption]::AllDirectories))
        $manifests | Should -HaveCount 1
        $shipped = Import-PowerShellDataFile -LiteralPath $manifests[0]
        [version] $shipped.ModuleVersion | Should -Be (Get-Module Pester).Version
    }
}
