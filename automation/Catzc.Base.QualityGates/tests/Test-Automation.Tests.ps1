<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/tests/Test-Automation.Tests.ps1
    kind: test
---
#>

# The source and test file conventions over the real tree, through their quality gate (Test-SourceConventions —
# [ADR-AUTO-TEST#35](/docs/adr/automation/test-automation.md#rule-adr-auto-test35)). The gate scans the tree once,
# parses each source file once, and lists every offender; this block runs it at its tier and guards it against a
# silent no-op.
# source-only: it reads the per-function source files, which give the same answer in both run modes.
Describe 'Source & test file conventions' -Tag 'L0', 'integrity', 'source-only' {
    BeforeAll {
        $script:result = Test-SourceConventions -PassThru -OutputFolder (Join-Path $TestDrive 'source-conventions')
    }

    It 'the scan found source and test files (guards the checks below against a silent no-op)' {
        # The conventions pass vacuously on an empty set, so prove the scan actually enumerated the tree.
        $result.SourceFiles | Should -BeGreaterThan 100
        $result.TestFiles | Should -BeGreaterThan 100
        $result.SkipReasons | Should -BeGreaterThan 10
    }

    It 'reports no source or test file convention issues' -Tag 'ADR-PWSH-PESTER#5', 'ADR-AUTO-TEST#43' {
        $result.IssueCount | Should -Be 0 -Because ($result.Issues -join "`n")
    }
}

# source-only: both dependency checks analyse the per-function source files (the same answer in both run modes).
Describe 'Function dependencies' -Tag 'L2', 'integrity', 'source-only' {
    It 'has no unresolved function calls' {
        (Test-FunctionDependency -PassThru -OutputFolder (Join-Path $TestDrive 'function-dependency')).IssueCount | Should -Be 0
    }
}

Describe 'Module dependencies' -Tag 'L0', 'integrity', 'source-only' {
    It 'has no circular module dependencies' {
        # The quality gate over the real call graph (Test-ModuleCycles, Catzc.Base.ModuleSystem).
        $result = Test-ModuleCycles -PassThru -OutputFolder (Join-Path $TestDrive 'module-cycles')
        $result.IssueCount | Should -Be 0 -Because ($result.Issues -join "`n")
    }
}

# The real-asset test of
# [ADR-AUTO-ASSETDEP#3](/docs/adr/automation/internal-asset-dependencies.md#rule-adr-auto-assetdep3) for
# Test-Automation's one internal asset: the vendored Pester under
# the code root. Pester is already loaded in this worker, so the lazy-load branch is forced by hiding it from
# Get-Module, and the re-import is intercepted (re-importing Pester mid-run would unload the running harness);
# the run stops at the first step after the import. The path it chose is then checked against the real shipped
# module on disk — integrity, and not source-only, so it runs in the source and the build run.
Describe 'Test-Automation (vendored Pester)' -Tag 'L1', 'integrity', 'ADR-AUTO-ASSETDEP#3' {
    BeforeAll {
        Mock Get-Module -ModuleName Catzc.Base.QualityGates -ParameterFilter { $Name -eq 'Pester' } { }
        # -PassThru answers with the module, as the real import does: the already-running Pester
        Mock Import-Module -ModuleName Catzc.Base.QualityGates -ParameterFilter { "$Name" -like '*Pester*' } { Get-Module Pester }
        Mock Get-TestAutomationTestPaths -ModuleName Catzc.Base.QualityGates { throw 'stop after the Pester import' }
    }

    It 'lazy-loads the vendored Pester from the code root, a real module matching the running Pester' {
        { Test-Automation } | Should -Throw '*stop after the Pester import*'

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
