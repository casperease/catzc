<#
---
catzc:
  derived:
    path: automation/.internal/tests/Write-LoadTime.Tests.ps1
    kind: pester-test
    adrs:
      - ADR-PWSH-CACHE#4
---
#>

BeforeAll {
    # The transient importer modules are removed after every import, so this test file loads its own copies.
    Import-Module (Join-Path $env:RepositoryRoot 'automation/.internal/Catzc.Internal.Bootstrap.psm1') -Force
    Import-Module (Join-Path $env:RepositoryRoot 'automation/.internal/Catzc.Internal.Importer.psm1') -Force
}

AfterAll {
    Remove-Module Catzc.Internal.Importer -Force -ErrorAction SilentlyContinue
    Remove-Module Catzc.Internal.Bootstrap -Force -ErrorAction SilentlyContinue
}

Describe 'Write-LoadTime' -Tag 'L0', 'logic', 'ADR-PWSH-CACHE#4' {
    BeforeEach {
        Mock Write-ImporterMessage { } -ModuleName Catzc.Internal.Importer
        InModuleScope Catzc.Internal.Importer { $script:diagSw = $null }
    }

    It 'starts the clock on a first call instead of throwing on the unset slot' {
        { InModuleScope Catzc.Internal.Importer { Write-LoadTime 'widget loaded' } } | Should -Not -Throw
        Should -Invoke Write-ImporterMessage -ModuleName Catzc.Internal.Importer -Times 1 -Exactly -ParameterFilter {
            $Message -match '^\s*\d+ms  widget loaded$'
        }
        InModuleScope Catzc.Internal.Importer { $script:diagSw.IsRunning } | Should -BeTrue
    }

    It 'reports the time since the previous stage and restarts the clock' {
        InModuleScope Catzc.Internal.Importer {
            $script:diagSw = [Diagnostics.Stopwatch]::new()
            $script:diagSw.Start()
            Write-LoadTime 'gadget loaded'
        }
        Should -Invoke Write-ImporterMessage -ModuleName Catzc.Internal.Importer -Times 1 -Exactly -ParameterFilter {
            $Message -like '*ms  gadget loaded'
        }
        InModuleScope Catzc.Internal.Importer { $script:diagSw.Elapsed.TotalSeconds } | Should -BeLessThan 5
    }
}
