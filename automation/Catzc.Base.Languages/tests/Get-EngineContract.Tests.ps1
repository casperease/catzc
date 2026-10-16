<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Languages/tests/Get-EngineContract.Tests.ps1
    kind: pester-test
    language: powershell
    track: automation
    module: Catzc.Base.Languages
    relatives:
      page: docs/references/automation/catzc-base-languages/tests/Get-EngineContract.Tests.ps1.md
      source: automation/Catzc.Base.Languages/private/Get-EngineContract.ps1
    adrs:
      - ADR-AUTO-TEST#3
---
#>

Describe 'Get-EngineContract' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:root = Join-Path $TestDrive "widget's repo"
        $null = New-Item -ItemType File -Path (Join-Path $script:root 'importer.sh') -Force
        $script:buildEntry = Join-Path $TestDrive 'build/Import-Catzc.ps1'
        $null = New-Item -ItemType File -Path $script:buildEntry -Force
        $script:bash = Join-Path $TestDrive 'widget bash/bash.exe'
        $null = New-Item -ItemType File -Path $script:bash -Force
        $script:zsh = Join-Path $TestDrive 'widget zsh/zsh.exe'
        $null = New-Item -ItemType File -Path $script:zsh -Force
    }

    BeforeEach {
        Mock Get-RepositoryRoot -ModuleName Catzc.Base.Languages { $script:root }
        Mock Resolve-EngineExecutable -ModuleName Catzc.Base.Languages -ParameterFilter { $Engine -eq 'pwsh' } { 'C:\widget\engine\pwsh.exe' }
    }

    It 'names pwsh, its start arguments loading the repository importer, and the root for a source run' {
        $contract = InModuleScope Catzc.Base.Languages { Get-EngineContract }
        @($contract.Keys) | Should -Be @('CATZC_ENGINE', 'CATZC_ENGINE_EXECUTABLE', 'CATZC_ENGINE_ENTRY', 'CATZC_ENGINE_START', 'CATZC_REPOSITORY_ROOT')
        $contract['CATZC_ENGINE_ENTRY'] | Should -Be (Join-Path $script:root 'importer.ps1')
        $contract['CATZC_ENGINE'] | Should -Be 'pwsh'
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

    It 'starts bash from the caller''s executable, loading importer.sh, with cats before the command and the build entry for cats' {
        $contract = InModuleScope Catzc.Base.Languages -Parameters @{ Bash = $script:bash; Entry = $script:buildEntry } {
            param($Bash, $Entry)
            Get-EngineContract -Engine bash -EngineExecutable $Bash -EntryScript $Entry
        }
        $contract['CATZC_ENGINE'] | Should -Be 'bash'
        $contract['CATZC_ENGINE_EXECUTABLE'] | Should -Be $script:bash
        $importer = (Join-Path $script:root 'importer.sh').Replace('\', '/')
        @($contract['CATZC_ENGINE_START'] | ConvertFrom-Json) | Should -Be ([Catzc.Base.Engines.ExecutionEngines]::Bash.StartArguments($importer, '{command}'))
        @($contract['CATZC_ENGINE_START'] | ConvertFrom-Json)[-1] | Should -BeLike '*; cats {command}'
        $contract['CATZC_IMPORTER'] | Should -Be (Resolve-Path -LiteralPath $script:buildEntry).ProviderPath
        $contract['CATZC_ENGINE_ENTRY'] | Should -Be $importer
        Should -Invoke Resolve-EngineExecutable -ModuleName Catzc.Base.Languages -Times 0
    }

    It 'starts zsh like bash: the same importer.sh, its own start arguments, cats before the command' {
        $contract = InModuleScope Catzc.Base.Languages -Parameters @{ Zsh = $script:zsh; Entry = $script:buildEntry } {
            param($Zsh, $Entry)
            Get-EngineContract -Engine zsh -EngineExecutable $Zsh -EntryScript $Entry
        }
        $contract['CATZC_ENGINE'] | Should -Be 'zsh'
        $contract['CATZC_ENGINE_EXECUTABLE'] | Should -Be $script:zsh
        $importer = (Join-Path $script:root 'importer.sh').Replace('\', '/')
        $start = @($contract['CATZC_ENGINE_START'] | ConvertFrom-Json)
        $start | Should -Be ([Catzc.Base.Engines.ExecutionEngines]::Zsh.StartArguments($importer, '{command}'))
        $start[0] | Should -Be '-f'
        $start[-1] | Should -BeLike '*; cats {command}'
        $contract['CATZC_IMPORTER'] | Should -Be (Resolve-Path -LiteralPath $script:buildEntry).ProviderPath
        $contract['CATZC_ENGINE_ENTRY'] | Should -Be $importer
    }

    It 'throws when the build''s entry does not exist' {
        { InModuleScope Catzc.Base.Languages { Get-EngineContract -EntryScript 'C:\widget\absent\Import-Catzc.ps1' } } | Should -Throw
    }
}
