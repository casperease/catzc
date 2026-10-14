# The importer's restart of a stale person console (ADR-AUTO-TYPES#15): who may be restarted
# (Test-ImporterRestartAllowed), and what the restart runs (Restart-ImporterSession) with the child shell mocked
# (Invoke-ChildShell), so no process starts. Neutral fixture names
# ([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
BeforeAll {
    # The transient importer modules are removed after every import, so this test file loads its own copies.
    Import-Module (Join-Path $env:RepositoryRoot 'automation/.internal/Catzc.Internal.Bootstrap.psm1') -Force
    Import-Module (Join-Path $env:RepositoryRoot 'automation/.internal/Catzc.Internal.Importer.psm1') -Force
}

AfterAll {
    Remove-Module Catzc.Internal.Importer -Force -ErrorAction SilentlyContinue
    Remove-Module Catzc.Internal.Bootstrap -Force -ErrorAction SilentlyContinue
}

Describe 'Test-ImporterRestartAllowed' -Tag 'L0', 'logic', 'ADR-AUTO-TYPES#15' {
    BeforeEach {
        Mock Get-SessionActor { 'Person' } -ModuleName Catzc.Internal.Importer
    }

    It 'allows a person importing at an interactive console' {
        InModuleScope Catzc.Internal.Importer { Test-ImporterRestartAllowed -IsConsoleSession -Interactive } | Should -BeTrue
    }

    It 'refuses a <_> session' -ForEach 'Agent', 'Pipeline' {
        $actor = $_
        Mock Get-SessionActor { $actor } -ModuleName Catzc.Internal.Importer
        InModuleScope Catzc.Internal.Importer { Test-ImporterRestartAllowed -IsConsoleSession -Interactive } | Should -BeFalse
    }

    It 'refuses an import from a script, and a redirected console' {
        InModuleScope Catzc.Internal.Importer { Test-ImporterRestartAllowed -Interactive } | Should -BeFalse
        InModuleScope Catzc.Internal.Importer { Test-ImporterRestartAllowed -IsConsoleSession } | Should -BeFalse
    }
}

Describe 'Invoke-StaleTypesRestart' -Tag 'L0', 'logic', 'ADR-AUTO-TYPES#15' {
    BeforeEach {
        Mock Get-LoadedTypeDrift { [pscustomobject]@{ Current = $script:isCurrent; Drift = [string[]] @(); Summary = 'stale' } } -ModuleName Catzc.Internal.Importer
        Mock Test-ImporterRestartAllowed { $script:allowed } -ModuleName Catzc.Internal.Importer
        Mock Restart-ImporterSession { } -ModuleName Catzc.Internal.Importer
        $script:isCurrent = $false
        $script:allowed = $true
    }

    It 'restarts stale types when allowed, passing on only the switches that are set, and says so' {
        # The importer passes $PSBoundParameters: a generic dictionary, whose IDictionary.Contains is not callable.
        $parameters = [System.Collections.Generic.Dictionary[string, object]]::new()
        $parameters['ExportPrivates'] = [switch] $true
        $parameters['AllowWarnings'] = [switch] $false
        $parameters['DiagnoseLoadTime'] = [switch] $true
        InModuleScope Catzc.Internal.Importer -Parameters @{ Bound = $parameters } {
            param($Bound)
            Invoke-StaleTypesRestart -ModulesRoot 'C:\widget\automation' -RepositoryRoot 'C:\widget' -IsConsoleSession -ImporterParameter $Bound
        } | Should -BeTrue
        Should -Invoke Restart-ImporterSession -ModuleName Catzc.Internal.Importer -Times 1 -Exactly -ParameterFilter {
            $ImporterPath -eq (Join-Path 'C:\widget' 'importer.ps1') -and ($ImporterSwitch -join ' ') -eq '-ExportPrivates -DiagnoseLoadTime'
        }
    }

    It 'goes on with the import when the types are current, or a restart is not allowed: <Case>' -ForEach @(
        @{ Case = 'current'; Current = $true; Allowed = $true }
        @{ Case = 'not allowed'; Current = $false; Allowed = $false }
    ) {
        $script:isCurrent = $Current
        $script:allowed = $Allowed
        InModuleScope Catzc.Internal.Importer {
            Invoke-StaleTypesRestart -ModulesRoot 'C:\widget\automation' -RepositoryRoot 'C:\widget' -ImporterParameter @{}
        } | Should -BeFalse
        Should -Invoke Restart-ImporterSession -ModuleName Catzc.Internal.Importer -Times 0 -Exactly
    }
}

Describe 'Restart-ImporterSession' -Tag 'L0', 'logic', 'ADR-AUTO-TYPES#15' {
    BeforeEach {
        Mock Invoke-ChildShell { } -ModuleName Catzc.Internal.Importer
        Mock Write-ImporterMessage { } -ModuleName Catzc.Internal.Importer
        $script:state = [pscustomobject]@{
            Summary = 'C# types changed since they were loaded (aaaa1111 -> bbbb2222).'
            Drift   = [string[]] @(1..7 | ForEach-Object { "changed Catzc.Widget/Gadget$_" })
        }
    }

    It 'starts the pwsh beside this one, dot-sourcing the importer with the same switches, and staying open' {
        InModuleScope Catzc.Internal.Importer -Parameters @{ State = $script:state } {
            param($State)
            Restart-ImporterSession -ImporterPath "C:\widget's repo\importer.ps1" -TypeState $State -ImporterSwitch '-ExportPrivates', '-AllowWarnings'
        }
        Should -Invoke Invoke-ChildShell -ModuleName Catzc.Internal.Importer -Times 1 -Exactly -ParameterFilter {
            [System.IO.Path]::GetDirectoryName($Executable) -eq $PSHOME -and
            ($Argument -join '|') -eq "-NoExit|-NoLogo|-Command|. 'C:\widget''s repo\importer.ps1' -ExportPrivates -AllowWarnings"
        }
    }

    It 'says what drifted (the first five, then a count), how to come back, and where it is on return' {
        InModuleScope Catzc.Internal.Importer -Parameters @{ State = $script:state } {
            param($State)
            Restart-ImporterSession -ImporterPath 'C:\widget\importer.ps1' -TypeState $State
        }
        Should -Invoke Write-ImporterMessage -ModuleName Catzc.Internal.Importer -Times 1 -Exactly -ParameterFilter {
            $Message -like '*aaaa1111 -> bbbb2222*Gadget5; and 2 more.'
        }
        Should -Invoke Write-ImporterMessage -ModuleName Catzc.Internal.Importer -Times 1 -Exactly -ParameterFilter { $Message -like '*Type exit there*' }
        Should -Invoke Write-ImporterMessage -ModuleName Catzc.Internal.Importer -Times 1 -Exactly -ParameterFilter { $Message -like 'Back in the earlier session*' }
    }
}
