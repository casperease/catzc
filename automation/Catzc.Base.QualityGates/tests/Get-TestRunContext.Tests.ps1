<#
---
catzc:
  immutable:
    path: automation/Catzc.Base.QualityGates/tests/Get-TestRunContext.Tests.ps1
    folder: tests
    name: get-test-run-context-tests
    filetype: ps1
    kind: test
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.QualityGates
    moduletype: pwsh-folder
    catzc_bundle: azure
  edges:
    page: docs/references/automation/catzc-base-qualitygates/tests/Get-TestRunContext.Tests.ps1.md
    cites:
      - ADR-AUTO-TEST#3
---
#>

Describe 'Get-TestRunContext' -Tag 'L0', 'logic' {
    BeforeAll {
        function script:New-FixtureLocation {
            param([string] $Mode = 'in-place', $Holder = $null, $SystemTestHolder = $null)
            [pscustomobject]@{ Mode = $Mode; Holder = $Holder; SystemTestHolder = $SystemTestHolder }
        }
        function script:Get-Context {
            param([hashtable] $Arguments)
            InModuleScope Catzc.Base.QualityGates -Parameters @{ A = $Arguments } {
                param($A)
                Get-TestRunContext @A
            }
        }
    }

    BeforeEach {
        Mock Get-SessionActor -ModuleName Catzc.Base.QualityGates { 'Person' }
        Mock Get-CatzcModulesRoot -ModuleName Catzc.Base.QualityGates { 'C:\widget\automation' }
        Mock Get-Command -ModuleName Catzc.Base.QualityGates -ParameterFilter { $Name -eq 'az' } { $null }
        Mock Get-Command -ModuleName Catzc.Base.QualityGates -ParameterFilter { $Name -in 'git', 'dotnet' } { [pscustomobject]@{ Name = $Name } }
    }

    It 'describes an in-place source run of all tests, running every tier asked for' {
        $context = Get-Context @{ EntryPoint = 'Test-Automation'; Location = (New-FixtureLocation); RequestedMaxLevel = 3; MaxLevel = 3 }
        $context.entryPoint | Should -Be 'Test-Automation'
        $context.run | Should -Be 'source'
        $context.codeRoot | Should -Be 'C:\widget\automation'
        $context.location | Should -Be 'in-place'
        $context.locationReason | Should -BeNullOrEmpty
        $context.tiersRequested | Should -Be 'L0-L3'
        $context.tiersRunning | Should -Be 'L0-L3'
        $context.tierCap | Should -BeNullOrEmpty
        $context.actor | Should -Be 'Person'
        $context.tools.git | Should -BeTrue
        $context.tools.az | Should -BeFalse
        $context.selection | Should -Be 'all tests'
    }

    It 'names who held the working folder and why L3 was skipped in a snapshot' {
        $location = New-FixtureLocation -Mode snapshot -Holder ([pscustomobject]@{ Description = 'Test-Automation, pid 4242' })
        $context = Get-Context @{ EntryPoint = 'Test-Automation'; Location = $location; RequestedMaxLevel = 3; MaxLevel = 2 }
        $context.location | Should -Be 'snapshot'
        $context.locationReason | Should -Be 'working folder held by Test-Automation, pid 4242'
        $context.tierCap | Should -Be 'L3 skipped: snapshot location'
    }

    It 'says -Isolated for a snapshot nobody forced, and names the system-test lock holder in place' {
        (Get-Context @{ EntryPoint = 'Test-Automation'; Location = (New-FixtureLocation -Mode snapshot) }).locationReason | Should -Be '-Isolated'
        $location = New-FixtureLocation -SystemTestHolder ([pscustomobject]@{ Description = 'Test-CatzcBuild, pid 7' })
        (Get-Context @{ EntryPoint = 'Test-Automation'; Location = $location; RequestedMaxLevel = 3; MaxLevel = 2 }).tierCap |
            Should -Be 'L3 skipped: system-test lock held by Test-CatzcBuild, pid 7'
    }

    It 'describes a build run by its entry script and joins the selection' {
        $context = Get-Context @{
            EntryPoint = 'Test-CatzcBuild'; EntryScript = 'C:\gadget\Import-Catzc.ps1'; Location = (New-FixtureLocation)
            Suite = 'widget'; Modules = @('TstWidget'); Category = 'Logic'; Rule = @('ADR-WI-ONE#1')
        }
        $context.run | Should -Be 'build'
        $context.codeRoot | Should -Be (Join-Path 'C:\gadget' 'automation')
        $context.selection | Should -Be 'suite widget; modules: TstWidget; category Logic; rules: ADR-WI-ONE#1'
    }
}
