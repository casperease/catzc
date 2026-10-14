Describe 'New-PesterRunConfiguration' -Tag 'L0', 'logic' {
    BeforeEach {
        Mock Get-LanguageTestFolders -ModuleName Catzc.Base.QualityGates {}
    }

    It 'runs a language test folder through the bridge container, with the entry script and the tool, and the rest by path' {
        $repo = Join-Path $TestDrive 'repo'
        $bridge = Join-Path $repo 'automation/Catzc.Base.QualityGates/tests/Language.Bridge.ps1'
        [void][System.IO.Directory]::CreateDirectory([System.IO.Path]::GetDirectoryName($bridge))
        [System.IO.File]::WriteAllText($bridge, '# fixture bridge')
        $script:widgetGo = [System.IO.Path]::GetFullPath((Join-Path $repo 'go/tests/catzc-widget'))
        Mock Get-RepositoryRoot -ModuleName Catzc.Base.QualityGates { Join-Path $TestDrive 'repo' }
        Mock Get-LanguageTestFolders -ModuleName Catzc.Base.QualityGates {
            [pscustomobject]@{ Language = 'go'; Module = 'Catzc.Widget'; Folder = $script:widgetGo; Name = 'catzc-widget' }
        }

        $config = InModuleScope Catzc.Base.QualityGates -Parameters @{ Go = $script:widgetGo } {
            param($Go)
            New-PesterRunConfiguration -Path 'a.Tests.ps1', $Go -EntryScript 'C:\build\Import-Catzc.ps1' -LanguageExecutable @{ go = 'C:\widget\go\bin\go.exe' }
        }
        @($config.Run.Path.Value) | Should -Be @('a.Tests.ps1')
        @($config.Run.Container.Value) | Should -HaveCount 1
        $config.Run.Container.Value[0].Data['Language'] | Should -Be 'go'
        $config.Run.Container.Value[0].Data['TestFolder'] | Should -Be $script:widgetGo
        $config.Run.Container.Value[0].Data['EntryScript'] | Should -Be 'C:\build\Import-Catzc.ps1'
        $config.Run.Container.Value[0].Data['Executable'] | Should -Be 'C:\widget\go\bin\go.exe'
    }

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

    It 'applies include tags (the -Rule provenance filter) only when given' {
        $with = InModuleScope Catzc.Base.QualityGates {
            New-PesterRunConfiguration -Path 'a.Tests.ps1' -IncludeTag 'ADR-FAKE#1'
        }
        @($with.Filter.Tag.Value) | Should -Be @('ADR-FAKE#1')

        $without = InModuleScope Catzc.Base.QualityGates {
            New-PesterRunConfiguration -Path 'a.Tests.ps1'
        }
        @($without.Filter.Tag.Value) | Should -HaveCount 0
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
