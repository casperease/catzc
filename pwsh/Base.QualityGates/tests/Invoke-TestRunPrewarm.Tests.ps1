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

    It 'runs nothing and takes no time when no selected folder holds a prewarm script' {
        $seconds = InModuleScope Catzc.Base.QualityGates -Parameters @{ File = (Join-Path $script:gadgetTests 'Gadget.Tests.ps1'); Run = $script:runDirectory } {
            param($File, $Run)
            Invoke-TestRunPrewarm -TestFile $File -RunDirectory $Run -WorkerEnvironment @{} -TimeoutSeconds 60
        }
        $seconds | Should -Be 0.0
        Test-Path (Join-Path $script:runDirectory 'prewarm-0.ps1') | Should -BeFalse
    }

    It 'runs nothing when the run blocks every real process' {
        $seconds = InModuleScope Catzc.Base.QualityGates -Parameters @{ File = (Join-Path $script:widgetTests 'Widget.Tests.ps1'); Run = $script:runDirectory } {
            param($File, $Run)
            Invoke-TestRunPrewarm -TestFile $File -RunDirectory $Run -TimeoutSeconds 60 `
                -WorkerEnvironment @{ CATZC_BLOCK_REAL_PROCESS = [Catzc.Base.Timeouts.TestTiers]::BlockEveryLaunch }
        }
        $seconds | Should -Be 0.0
        Test-Path (Join-Path $script:runDirectory 'prewarm-0.ps1') | Should -BeFalse
    }
}
