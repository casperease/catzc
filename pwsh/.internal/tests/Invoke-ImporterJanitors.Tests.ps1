[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidGlobalVars', '',
    Justification = 'Tests lift $global:__PesterRunning to verify writer output; that flag is the writers'' test-suppression interface, set by Test-Automation')]
param()

Describe 'a janitor line after the import has removed Bootstrap' -Tag 'L0', 'logic' {
    BeforeAll {
        # The state the deferred janitor action meets: Bootstrap removed, only the Importer module loaded.
        Remove-Module Catzc.Internal.Bootstrap -Force -ErrorAction SilentlyContinue
        Import-InternalModule Importer -Force
        $script:savedGuard = Get-Variable -Name '__PesterRunning' -Scope Global -ValueOnly -ErrorAction Ignore
        $script:termProgram = $env:TERM_PROGRAM
    }

    AfterAll {
        $global:__PesterRunning = $script:savedGuard
        $env:TERM_PROGRAM = $script:termProgram
        Remove-Module Catzc.Internal.Importer -Force -ErrorAction SilentlyContinue
    }

    BeforeEach {
        $global:__PesterRunning = $false
        $env:TERM_PROGRAM = 'vscode'
        Mock Get-Command { [pscustomobject] @{ Name = 'code' } } -ModuleName Catzc.Internal.Importer -ParameterFilter { $Name -in 'Install-VsCodeExtension', 'code' }
        Mock Get-SessionActor { 'User' } -ModuleName Catzc.Internal.Importer
    }

    It 'prints through the loader writer instead of throwing' -Tag 'ADR-PWSH-ANNOUNCE-IMPORTERLOADSEQUENCE' {
        Get-Module Catzc.Internal.Bootstrap | Should -BeNullOrEmpty
        $info = InModuleScope Catzc.Internal.Importer { Invoke-EditorExtensionJanitor } 6>&1
        ($info -join "`n") | Should -BeLike '*Editor extensions: not installed from inside VS Code*'
    }
}

Describe 'Invoke-ImporterJanitors' -Tag 'L0', 'logic' {
    BeforeAll {
        Remove-Module Catzc.Internal.Importer -Force -ErrorAction SilentlyContinue
        Import-InternalModule Importer -Force
    }

    AfterAll {
        $global:__janitorOrder = $null
        Remove-Module Catzc.Internal.Importer -Force -ErrorAction SilentlyContinue
    }

    It 'checks the generated files before any janitor re-renders' -Tag 'ADR-REPO-FILEMETA-INTUNEWITHGENERATOR' {
        $global:__janitorOrder = [System.Collections.Generic.List[string]]::new()
        Mock Invoke-GeneratedFilesJanitor { $global:__janitorOrder.Add('generated-files') } -ModuleName Catzc.Internal.Importer
        Mock Invoke-TypeCacheJanitor { $global:__janitorOrder.Add('type-cache') } -ModuleName Catzc.Internal.Importer
        Mock Invoke-AgentHookJanitor { $global:__janitorOrder.Add('agent-hook') } -ModuleName Catzc.Internal.Importer
        Mock Invoke-EditorExtensionJanitor { $global:__janitorOrder.Add('editor-extension') } -ModuleName Catzc.Internal.Importer
        Mock Get-Command { $null } -ModuleName Catzc.Internal.Importer

        InModuleScope Catzc.Internal.Importer { Invoke-ImporterJanitors }

        @($global:__janitorOrder) | Should -Be @('generated-files', 'type-cache', 'agent-hook', 'editor-extension')
    }
}

Describe 'the build janitors and the writers lists' -Tag 'L0', 'logic' {
    BeforeAll {
        Remove-Module Catzc.Internal.Importer -Force -ErrorAction SilentlyContinue
        Import-InternalModule Importer -Force
    }

    AfterAll {
        Remove-Module Catzc.Internal.Importer -Force -ErrorAction SilentlyContinue
    }

    BeforeEach {
        foreach ($name in 'Invoke-GeneratedFilesJanitor', 'Invoke-TypeCacheJanitor', 'Invoke-AgentHookJanitor',
            'Invoke-EditorExtensionJanitor', 'Sync-SessionTools', 'Build-DrsIndex', 'Build-Glossary',
            'Build-ContractReference', 'Build-Readme', 'Build-GitKeep', 'Build-TerminologyDictionary',
            'Build-DrsCodeDictionary', 'Build-RootConfig') {
            Mock $name { } -ModuleName Catzc.Internal.Importer
        }
        $script:writers = [ordered]@{}
        foreach ($name in 'Build-DrsIndex', 'Build-Glossary', 'Build-ContractReference', 'Build-Readme',
            'Build-GitKeep', 'Build-TerminologyDictionary', 'Build-DrsCodeDictionary', 'Build-RootConfig') {
            $script:writers[$name] = [pscustomobject]@{ name = $name; at_import = $true }
        }
        $script:writers['Build-EnglishDictionary'] = [pscustomobject]@{ name = 'Build-EnglishDictionary'; at_import = $false }
        Mock Get-GeneratedWriterOrder { $script:writers.Values } -ModuleName Catzc.Internal.Importer
        Mock Build-EnglishDictionary { } -ModuleName Catzc.Internal.Importer
        # A writer the janitor runs stores its stamp; the test keeps that out of the repository's memo.
        Mock Save-GeneratedWriterStamp { } -ModuleName Catzc.Internal.Importer
        $script:rows = @(
            foreach ($name in 'Build-DrsIndex', 'Build-Glossary', 'Build-ContractReference', 'Build-Readme',
                'Build-GitKeep', 'Build-TerminologyDictionary', 'Build-DrsCodeDictionary', 'Build-RootConfig') {
                [pscustomobject]@{ Name = $name; Due = $false }
            }
        )
    }

    It 're-renders a writer whose lists match the changed set and skips one whose lists do not' {
        ($script:rows | Where-Object Name -eq 'Build-DrsIndex').Due = $true
        Mock Get-GeneratedWriterDue { $script:rows } -ModuleName Catzc.Internal.Importer

        InModuleScope Catzc.Internal.Importer { Invoke-ImporterJanitors }

        Should -Invoke Build-DrsIndex -ModuleName Catzc.Internal.Importer -Times 1 -Exactly
        Should -Invoke Build-Glossary -ModuleName Catzc.Internal.Importer -Times 0 -Exactly
        Should -Invoke Build-Readme -ModuleName Catzc.Internal.Importer -Times 0 -Exactly
    }

    It 're-renders a writer whose output is missing, which the due rows already say' {
        ($script:rows | Where-Object Name -eq 'Build-GitKeep').Due = $true
        Mock Get-GeneratedWriterDue { $script:rows } -ModuleName Catzc.Internal.Importer

        InModuleScope Catzc.Internal.Importer { Invoke-ImporterJanitors }

        Should -Invoke Build-GitKeep -ModuleName Catzc.Internal.Importer -Times 1 -Exactly
    }

    It 'runs no writer when no row is due' {
        Mock Get-GeneratedWriterDue { $script:rows } -ModuleName Catzc.Internal.Importer

        InModuleScope Catzc.Internal.Importer { Invoke-ImporterJanitors }

        Should -Invoke Build-RootConfig -ModuleName Catzc.Internal.Importer -Times 0 -Exactly
        Should -Invoke Build-DrsIndex -ModuleName Catzc.Internal.Importer -Times 0 -Exactly
    }

    It 'runs a writer the due rows do not name' {
        Mock Get-GeneratedWriterDue { $script:rows | Where-Object Name -ne 'Build-RootConfig' } -ModuleName Catzc.Internal.Importer

        InModuleScope Catzc.Internal.Importer { Invoke-ImporterJanitors }

        Should -Invoke Build-RootConfig -ModuleName Catzc.Internal.Importer -Times 1 -Exactly
        Should -Invoke Build-DrsIndex -ModuleName Catzc.Internal.Importer -Times 0 -Exactly
    }

    It 'considers only the writer rows marked at_import, none of its own list' {
        ($script:rows | Where-Object Name -eq 'Build-Glossary').Due = $true
        Mock Get-GeneratedWriterDue { $script:rows } -ModuleName Catzc.Internal.Importer
        $script:writers['Build-Glossary'].at_import = $false

        InModuleScope Catzc.Internal.Importer { Invoke-ImporterJanitors }

        Should -Invoke Build-Glossary -ModuleName Catzc.Internal.Importer -Times 0 -Exactly
        Should -Invoke Build-EnglishDictionary -ModuleName Catzc.Internal.Importer -Times 0 -Exactly
    }

    It 'runs every build janitor when the due rows cannot be read' {
        Mock Get-GeneratedWriterDue { throw 'git is not available' } -ModuleName Catzc.Internal.Importer
        Mock Write-ImporterMessage { } -ModuleName Catzc.Internal.Importer

        InModuleScope Catzc.Internal.Importer { Invoke-ImporterJanitors }

        Should -Invoke Build-DrsIndex -ModuleName Catzc.Internal.Importer -Times 1 -Exactly
        Should -Invoke Build-RootConfig -ModuleName Catzc.Internal.Importer -Times 1 -Exactly
        Should -Invoke Write-ImporterMessage -ModuleName Catzc.Internal.Importer -Times 1 -Exactly -ParameterFilter { $Message -like 'Build janitors: all run*git is not available*' }
    }
}
