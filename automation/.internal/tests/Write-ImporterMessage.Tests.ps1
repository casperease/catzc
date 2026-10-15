<#
---
catzc:
  derived:
    path: automation/.internal/tests/Write-ImporterMessage.Tests.ps1
    kind: pester-test
---
#>

[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidGlobalVars', '', Justification = 'Tests lift $global:__PesterRunning to verify writer output; that flag is the writers'' test-suppression interface, set by Test-Automation')]
param()

Describe 'Write-ImporterMessage' -Tag 'L0', 'logic' {
    BeforeAll {
        Import-Module (Join-Path $env:RepositoryRoot 'automation/.internal/Catzc.Internal.Bootstrap.psm1') -Force
        $script:savedGuard = Get-Variable -Name '__PesterRunning' -Scope Global -ValueOnly -ErrorAction Ignore
    }

    AfterAll {
        $global:__PesterRunning = $script:savedGuard
        Remove-Module Catzc.Internal.Bootstrap -Force -ErrorAction SilentlyContinue
    }

    BeforeEach {
        $global:__PesterRunning = $false
        Set-ImporterVerbosity -Enabled $false
    }

    It 'writes a plain line on the information stream' {
        $info = Write-ImporterMessage 'widget ready' 6>&1 4>$null
        @($info).Count | Should -Be 1
        "$info" | Should -Be '[Importer.ps1] widget ready'
    }

    It 'writes nothing for a -StateChange line when verbosity is off' {
        $all = Write-ImporterMessage 'Loaded widget' -StateChange 6>&1 4>&1
        @($all).Count | Should -Be 0
    }

    It 'writes a -StateChange line on the verbose stream, not the information stream, when verbosity is on' {
        Set-ImporterVerbosity -Enabled $true
        $verbose = Write-ImporterMessage 'Loaded widget' -StateChange 6>$null 4>&1
        $info = Write-ImporterMessage 'Loaded widget' -StateChange 6>&1 4>$null
        @($verbose).Count | Should -Be 1
        $verbose[0] | Should -BeOfType System.Management.Automation.VerboseRecord
        $verbose[0].Message | Should -Be '[Importer.ps1] Loaded widget'
        @($info).Count | Should -Be 0
    }

    It 'stays silent for a -StateChange line during a Pester run' {
        Set-ImporterVerbosity -Enabled $true
        $global:__PesterRunning = $true
        $all = Write-ImporterMessage 'Loaded widget' -StateChange 6>&1 4>&1
        @($all).Count | Should -Be 0
    }

    It 'starts with verbosity off on a fresh import of the bootstrap' {
        Set-ImporterVerbosity -Enabled $true
        Import-Module (Join-Path $env:RepositoryRoot 'automation/.internal/Catzc.Internal.Bootstrap.psm1') -Force
        $all = Write-ImporterMessage 'Loaded widget' -StateChange 6>&1 4>&1
        @($all).Count | Should -Be 0
    }
}
