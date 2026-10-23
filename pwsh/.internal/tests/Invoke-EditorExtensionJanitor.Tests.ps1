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

Describe 'Invoke-EditorExtensionJanitor' -Tag 'L0', 'logic' {
    BeforeEach {
        Mock Get-Command { [pscustomobject] @{ Name = 'code' } } -ModuleName Catzc.Internal.Importer -ParameterFilter { $Name -eq 'code' }
        Mock Get-SessionActor { 'User' } -ModuleName Catzc.Internal.Importer
        Mock Install-VsCodeExtension { 'widget.vsix' } -ModuleName Catzc.Internal.Importer
        Mock Write-ImporterMessage { } -ModuleName Catzc.Internal.Importer
    }

    It 'skips inside VS Code with one line naming the command to run from outside' {
        $env:TERM_PROGRAM = 'vscode'
        InModuleScope Catzc.Internal.Importer { Invoke-EditorExtensionJanitor }
        Should -Invoke Install-VsCodeExtension -ModuleName Catzc.Internal.Importer -Times 0 -Exactly
        Should -Invoke Write-ImporterMessage -ModuleName Catzc.Internal.Importer -Times 1 -Exactly -ParameterFilter { $Message -like '*Install-VsCodeExtension*outside*' }
    }

    It 'installs outside VS Code and reports the installed package' {
        $env:TERM_PROGRAM = 'WindowsTerminal'
        InModuleScope Catzc.Internal.Importer { Invoke-EditorExtensionJanitor }
        Should -Invoke Install-VsCodeExtension -ModuleName Catzc.Internal.Importer -Times 1 -Exactly
        Should -Invoke Write-ImporterMessage -ModuleName Catzc.Internal.Importer -Times 1 -Exactly -ParameterFilter { $Message -like 'Editor extension installed: widget.vsix*' }
    }

    It 'does nothing in a pipeline' {
        $env:TERM_PROGRAM = 'WindowsTerminal'
        Mock Get-SessionActor { 'Pipeline' } -ModuleName Catzc.Internal.Importer
        InModuleScope Catzc.Internal.Importer { Invoke-EditorExtensionJanitor }
        Should -Invoke Install-VsCodeExtension -ModuleName Catzc.Internal.Importer -Times 0 -Exactly
        Should -Invoke Write-ImporterMessage -ModuleName Catzc.Internal.Importer -Times 0 -Exactly
    }
}
