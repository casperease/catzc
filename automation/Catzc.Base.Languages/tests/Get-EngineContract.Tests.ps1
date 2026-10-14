# Get-EngineContract with the engine's executable mocked: the start arguments come from the execution engine model and
# load the run's entry. Neutral fixture paths ([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
Describe 'Get-EngineContract' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:root = Join-Path $TestDrive "widget's repo"
        $null = New-Item -ItemType Directory -Path $script:root -Force
        $script:buildEntry = Join-Path $TestDrive 'build/Import-Catzc.ps1'
        $null = New-Item -ItemType File -Path $script:buildEntry -Force
    }

    BeforeEach {
        Mock Get-RepositoryRoot -ModuleName Catzc.Base.Languages { $script:root }
        Mock Resolve-EngineExecutable -ModuleName Catzc.Base.Languages -ParameterFilter { $Engine -eq 'pwsh' } { 'C:\widget\engine\pwsh.exe' }
    }

    It 'names the pwsh executable, the start arguments loading the repository importer, and the root for a source run' {
        $contract = InModuleScope Catzc.Base.Languages { Get-EngineContract }
        @($contract.Keys) | Should -Be @('CATZC_ENGINE_EXECUTABLE', 'CATZC_ENGINE_START', 'CATZC_REPOSITORY_ROOT')
        $contract['CATZC_ENGINE_EXECUTABLE'] | Should -Be 'C:\widget\engine\pwsh.exe'
        $start = @($contract['CATZC_ENGINE_START'] | ConvertFrom-Json)
        $start | Should -Be ([Catzc.Base.Engines.ExecutionEngines]::Pwsh.StartArguments((Join-Path $script:root 'importer.ps1'), '{command}'))
        $start[-1] | Should -BeLike "*widget''s repo*; {command}"
        $contract['CATZC_REPOSITORY_ROOT'] | Should -Be $script:root
    }

    It 'loads the build''s entry for a build run' {
        $contract = InModuleScope Catzc.Base.Languages -Parameters @{ Entry = $script:buildEntry } { param($Entry) Get-EngineContract -EntryScript $Entry }
        @($contract['CATZC_ENGINE_START'] | ConvertFrom-Json)[-1] | Should -BeLike "*Import-Catzc.ps1' *> `$null; {command}"
    }

    It 'throws when the build''s entry does not exist' {
        { InModuleScope Catzc.Base.Languages { Get-EngineContract -EntryScript 'C:\widget\absent\Import-Catzc.ps1' } } | Should -Throw
    }
}
