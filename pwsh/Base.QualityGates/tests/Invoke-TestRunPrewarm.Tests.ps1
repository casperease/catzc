Describe 'Invoke-TestRunPrewarm' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:widgetTests = Join-Path $TestDrive 'Widget/tests'
        $script:gadgetTests = Join-Path $TestDrive 'Gadget/tests'
        $null = New-Item -ItemType Directory -Path $script:widgetTests, $script:gadgetTests -Force
        $script:prewarm = Join-Path $script:widgetTests 'Widget.Prewarm.ps1'
        Set-Content -LiteralPath $script:prewarm -Value '# widget prewarm'
        $script:runDirectory = Join-Path $TestDrive 'run'
        $null = New-Item -ItemType Directory -Path $script:runDirectory -Force
    }

    BeforeEach {
        Mock Write-Message -ModuleName Catzc.Base.QualityGates { }
        Mock Get-TestRunEntryLine -ModuleName Catzc.Base.QualityGates { ". 'C:\widget/importer.ps1' -SkipJanitors" }
    }

    It 'starts nothing and waits for nothing when no selected folder holds a prewarm script' {
        $result = InModuleScope Catzc.Base.QualityGates -Parameters @{ File = (Join-Path $script:gadgetTests 'Gadget.Tests.ps1'); Run = $script:runDirectory } {
            param($File, $Run)
            $handle = Start-TestRunPrewarm -TestFile $File -RunDirectory $Run -WorkerEnvironment @{} -TimeoutSeconds 60
            @{ Handle = $handle; Seconds = (Invoke-TestRunPrewarm -Prewarm $handle) }
        }
        $result.Handle | Should -BeNullOrEmpty
        $result.Seconds | Should -Be 0.0
        Test-Path (Join-Path $script:runDirectory 'prewarm-0.ps1') | Should -BeFalse
    }

    It 'starts nothing when the run blocks every real process' {
        $handle = InModuleScope Catzc.Base.QualityGates -Parameters @{ File = (Join-Path $script:widgetTests 'Widget.Tests.ps1'); Run = $script:runDirectory } {
            param($File, $Run)
            Start-TestRunPrewarm -TestFile $File -RunDirectory $Run -TimeoutSeconds 60 `
                -WorkerEnvironment @{ CATZC_BLOCK_REAL_PROCESS = [Catzc.Base.Timeouts.TestTiers]::BlockEveryLaunch }
        }
        $handle | Should -BeNullOrEmpty
        Test-Path (Join-Path $script:runDirectory 'prewarm-0.ps1') | Should -BeFalse
    }

    It 'starts the prewarm script, then the wait reports its exit and the seconds' {
        $seconds = InModuleScope Catzc.Base.QualityGates -Parameters @{ File = (Join-Path $script:widgetTests 'Widget.Tests.ps1'); Run = $script:runDirectory } {
            param($File, $Run)
            $handle = Start-TestRunPrewarm -TestFile $File -RunDirectory $Run -WorkerEnvironment @{} -TimeoutSeconds 60
            Invoke-TestRunPrewarm -Prewarm $handle
        }
        Test-Path (Join-Path $script:runDirectory 'prewarm-0.ps1') | Should -BeTrue
        $seconds | Should -BeGreaterThan 0
        # The entry line is a stand-in that cannot load the engine, so the worker exits non-zero and the wait says so.
        Should -Invoke Write-Message -ModuleName Catzc.Base.QualityGates -ParameterFilter { $Message -like 'Prewarm Widget.Prewarm.ps1 exited*' }
        Should -Invoke Write-Message -ModuleName Catzc.Base.QualityGates -ParameterFilter { $Message -like 'Prewarm done in *' }
    }
}
