Describe 'New-PesterRunConfiguration' -Tag 'L0', 'logic' {
    It 'configures paths, pass-thru, and verbosity' {
        $config = InModuleScope Catzc.Base.QualityGates {
            New-PesterRunConfiguration -Path 'a.Tests.ps1', 'b.Tests.ps1' -Verbosity Diagnostic
        }
        @($config.Run.Path.Value) | Should -Be @('a.Tests.ps1', 'b.Tests.ps1')
        $config.Run.PassThru.Value | Should -BeTrue
        # Pester maps legacy 'Minimal' to 'Normal' internally; assert with a value it keeps verbatim.
        $config.Output.Verbosity.Value | Should -Be 'Diagnostic'
        $config.TestResult.Enabled.Value | Should -BeFalse
    }

    It 'applies exclude tags only when given' {
        $with = InModuleScope Catzc.Base.QualityGates {
            New-PesterRunConfiguration -Path 'a.Tests.ps1' -ExcludeTag 'L2', 'L3'
        }
        @($with.Filter.ExcludeTag.Value) | Should -Be @('L2', 'L3')

        $without = InModuleScope Catzc.Base.QualityGates {
            New-PesterRunConfiguration -Path 'a.Tests.ps1'
        }
        @($without.Filter.ExcludeTag.Value) | Should -HaveCount 0
    }

    It 'enables the NUnit result file only when ResultsPath is given' {
        $resultsPath = Join-Path $TestDrive 'results.xml'
        $config = InModuleScope Catzc.Base.QualityGates -Parameters @{ ResultsPath = $resultsPath } {
            param($ResultsPath) New-PesterRunConfiguration -Path 'a.Tests.ps1' -ResultsPath $ResultsPath
        }
        $config.TestResult.Enabled.Value | Should -BeTrue
        $config.TestResult.OutputFormat.Value | Should -Be 'NUnitXml'
        $config.TestResult.OutputPath.Value | Should -Be $resultsPath
        $config.TestResult.TestSuiteName.Value | Should -Be 'Catzc'
    }

    It 'wraps a FullNameFilter in wildcards for the single-check path' {
        $config = InModuleScope Catzc.Base.QualityGates {
            New-PesterRunConfiguration -Path 'a.Tests.ps1' -FullNameFilter 'Config conventions'
        }
        @($config.Filter.FullName.Value) | Should -Be @('*Config conventions*')
    }
}
