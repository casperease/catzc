BeforeAll {
    # The transient importer modules are removed after every import, so this test file loads its own copies.
    Import-Module (Join-Path (Get-CatzcModulesRoot) '.internal/Catzc.Internal.Bootstrap.psm1') -Force
    Import-Module (Join-Path (Get-CatzcModulesRoot) '.internal/Catzc.Internal.Importer.psm1') -Force
    $script:termProgram = $env:TERM_PROGRAM
}

AfterAll {
    $env:TERM_PROGRAM = $script:termProgram
    Remove-Module Catzc.Internal.Importer -Force -ErrorAction SilentlyContinue
    Remove-Module Catzc.Internal.Bootstrap -Force -ErrorAction SilentlyContinue
}

Describe 'Invoke-AgentHookJanitor' -Tag 'L0', 'logic' {
    BeforeEach {
        Mock Get-Command { [pscustomobject] @{ Name = 'widget' } } -ModuleName Catzc.Internal.Importer -ParameterFilter { $Name -in 'Build-AgentHook', 'dotnet' }
        Mock Get-SessionActor { 'User' } -ModuleName Catzc.Internal.Importer
        Mock Test-Path { $true } -ModuleName Catzc.Internal.Importer
        Mock Build-AgentHook { 'Assert-WidgetTimeout', 'Record-GadgetWrite' } -ModuleName Catzc.Internal.Importer -ParameterFilter { $ListStale }
        Mock Build-AgentHook { } -ModuleName Catzc.Internal.Importer
        Mock Write-ImporterMessage { } -ModuleName Catzc.Internal.Importer
    }

    It 'inside VS Code, builds nothing and prints one line naming the stale hooks and the command to run from outside' {
        $env:TERM_PROGRAM = 'vscode'
        InModuleScope Catzc.Internal.Importer { Invoke-AgentHookJanitor }
        Should -Invoke Build-AgentHook -ModuleName Catzc.Internal.Importer -Times 0 -Exactly -ParameterFilter { -not $ListStale }
        Should -Invoke Write-ImporterMessage -ModuleName Catzc.Internal.Importer -Times 1 -Exactly -ParameterFilter { $Message -like '*Assert-WidgetTimeout, Record-GadgetWrite stale*Build-AgentHook*outside*' }
    }

    It 'inside VS Code, prints nothing while every hook is current' {
        $env:TERM_PROGRAM = 'vscode'
        Mock Build-AgentHook { } -ModuleName Catzc.Internal.Importer -ParameterFilter { $ListStale }
        InModuleScope Catzc.Internal.Importer { Invoke-AgentHookJanitor }
        Should -Invoke Write-ImporterMessage -ModuleName Catzc.Internal.Importer -Times 0 -Exactly
    }

    It 'inside VS Code, says in one line that it did not check when the comparison throws' {
        $env:TERM_PROGRAM = 'vscode'
        Mock Build-AgentHook { throw 'No hook files' } -ModuleName Catzc.Internal.Importer -ParameterFilter { $ListStale }
        InModuleScope Catzc.Internal.Importer { Invoke-AgentHookJanitor }
        Should -Invoke Write-ImporterMessage -ModuleName Catzc.Internal.Importer -Times 1 -Exactly -ParameterFilter { $Message -like 'Agent hooks: not checked — No hook files*' }
    }

    It 'builds the hooks outside VS Code' {
        $env:TERM_PROGRAM = 'WindowsTerminal'
        InModuleScope Catzc.Internal.Importer { Invoke-AgentHookJanitor }
        Should -Invoke Build-AgentHook -ModuleName Catzc.Internal.Importer -Times 1 -Exactly -ParameterFilter { -not $ListStale }
        Should -Invoke Write-ImporterMessage -ModuleName Catzc.Internal.Importer -Times 0 -Exactly
    }

    It 'does nothing in a pipeline' {
        $env:TERM_PROGRAM = 'WindowsTerminal'
        Mock Get-SessionActor { 'Pipeline' } -ModuleName Catzc.Internal.Importer
        InModuleScope Catzc.Internal.Importer { Invoke-AgentHookJanitor }
        Should -Invoke Build-AgentHook -ModuleName Catzc.Internal.Importer -Times 0 -Exactly
    }
}
