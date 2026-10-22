BeforeAll {
    # The transient importer modules are removed after every import, so this test file loads its own copies.
    Import-Module (Join-Path (Get-CatzcModulesRoot) '.internal/Catzc.Internal.Bootstrap.psm1') -Force
    Import-Module (Join-Path (Get-CatzcModulesRoot) '.internal/Catzc.Internal.Importer.psm1') -Force
}

AfterAll {
    Remove-Module Catzc.Internal.Importer -Force -ErrorAction SilentlyContinue
    Remove-Module Catzc.Internal.Bootstrap -Force -ErrorAction SilentlyContinue
}

Describe 'Invoke-TypeCacheJanitor' -Tag 'L0', 'logic' {
    BeforeEach {
        Mock Clear-ModuleTypeCache { } -ModuleName Catzc.Internal.Importer
        Mock Write-ImporterMessage { } -ModuleName Catzc.Internal.Importer
        Mock Get-SessionActor { 'Person' } -ModuleName Catzc.Internal.Importer
    }

    It 'runs the janitor silently in a <_> session, with no switch that could stop a holder' -ForEach 'Person', 'Agent', 'Pipeline' {
        $actor = $_
        Mock Get-SessionActor { $actor } -ModuleName Catzc.Internal.Importer
        InModuleScope Catzc.Internal.Importer { Invoke-TypeCacheJanitor }
        Should -Invoke Clear-ModuleTypeCache -ModuleName Catzc.Internal.Importer -Times 1 -Exactly -ParameterFilter {
            $Silent -and -not $PSBoundParameters.ContainsKey('StopLockingProcesses')
        }
    }

    It 'shows the report with -ShowReport' {
        InModuleScope Catzc.Internal.Importer { Invoke-TypeCacheJanitor -ShowReport }
        Should -Invoke Clear-ModuleTypeCache -ModuleName Catzc.Internal.Importer -Times 1 -Exactly -ParameterFilter { -not $Silent }
    }

    It 'turns a failed delete into one red line instead of failing the load' {
        Mock Clear-ModuleTypeCache { throw 'Could not remove Catzc.Types.widget01.dll' } -ModuleName Catzc.Internal.Importer
        { InModuleScope Catzc.Internal.Importer { Invoke-TypeCacheJanitor } } | Should -Not -Throw
        Should -Invoke Write-ImporterMessage -ModuleName Catzc.Internal.Importer -Times 1 -Exactly -ParameterFilter {
            $Message -like '*Catzc.Types.widget01.dll*' -and $ForegroundColor -eq 'Red'
        }
    }
}
