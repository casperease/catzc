BeforeAll {
    # The transient importer modules are removed after every import, so this test file loads its own copies.
    Import-Module (Join-Path $env:RepositoryRoot 'automation/.internal/Catzc.Internal.Bootstrap.psm1') -Force
    Import-Module (Join-Path $env:RepositoryRoot 'automation/.internal/Catzc.Internal.Importer.psm1') -Force
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

    It 'runs the janitor silently and stops holders in a person''s devbox session' {
        InModuleScope Catzc.Internal.Importer { Invoke-TypeCacheJanitor }
        Should -Invoke Clear-ModuleTypeCache -ModuleName Catzc.Internal.Importer -Times 1 -Exactly -ParameterFilter {
            $Silent -and $StopLockingProcesses
        }
    }

    It 'shows the report with -ShowReport' {
        InModuleScope Catzc.Internal.Importer { Invoke-TypeCacheJanitor -ShowReport }
        Should -Invoke Clear-ModuleTypeCache -ModuleName Catzc.Internal.Importer -Times 1 -Exactly -ParameterFilter { -not $Silent }
    }

    It 'never stops holders in a <_> session' -ForEach 'Pipeline', 'Agent' {
        $actor = $_
        Mock Get-SessionActor { $actor } -ModuleName Catzc.Internal.Importer
        InModuleScope Catzc.Internal.Importer { Invoke-TypeCacheJanitor }
        Should -Invoke Clear-ModuleTypeCache -ModuleName Catzc.Internal.Importer -Times 1 -Exactly -ParameterFilter { -not $StopLockingProcesses }
    }

    It 'turns a failed delete into one red line instead of failing the load' {
        Mock Clear-ModuleTypeCache { throw 'Could not remove Catzc.Types.widget01.dll' } -ModuleName Catzc.Internal.Importer
        { InModuleScope Catzc.Internal.Importer { Invoke-TypeCacheJanitor } } | Should -Not -Throw
        Should -Invoke Write-ImporterMessage -ModuleName Catzc.Internal.Importer -Times 1 -Exactly -ParameterFilter {
            $Message -like '*Catzc.Types.widget01.dll*' -and $ForegroundColor -eq 'Red'
        }
    }
}
