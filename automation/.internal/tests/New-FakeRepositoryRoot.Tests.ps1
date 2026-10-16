<#
---
catzc:
  immutable:
    path: automation/.internal/tests/New-FakeRepositoryRoot.Tests.ps1
    name: new-fake-repository-root-tests
    filetype: ps1
    kind: test
    language: powershell
    track: automation
    module: Catzc.Internal.Tests
    moduletype: pwsh-folder
    catzc_bundle: minimal
  edges:
    cites:
      - ADR-DSGN-RUNMODE#4
---
#>

Describe 'New-FakeRepositoryRoot' -Tag 'L0', 'logic', 'ADR-DSGN-RUNMODE#4' {
    BeforeAll {
        Import-InternalModule TestKit
    }

    BeforeEach {
        $script:before = @{ RepositoryRoot = $env:RepositoryRoot; CatzcModulesRoot = $env:CatzcModulesRoot }
    }
    AfterEach {
        # Belt and braces: never leak a fake root into the next test, whatever an assertion did.
        $env:RepositoryRoot = $script:before.RepositoryRoot
        $env:CatzcModulesRoot = $script:before.CatzcModulesRoot
    }

    It 'points both roots at the fake tree, so it reads as source mode' {
        $fake = New-FakeRepositoryRoot -Modules @{ 'Catzc.Widget' = @{ Public = 'Get-Widget' } }
        try {
            $env:RepositoryRoot | Should -Be $fake.Root
            $env:CatzcModulesRoot | Should -Be $fake.Automation
            Get-CatzcRunMode | Should -Be 'source'
            Join-Path $fake.Automation 'Catzc.Widget/Get-Widget.ps1' | Should -Exist
        }
        finally {
            Remove-FakeRepositoryRoot $fake
        }
    }

    It 'restores both roots and deletes the tree on removal' {
        $fake = New-FakeRepositoryRoot -Files @{ 'widgets/gadget.txt' = 'gadget' }
        Remove-FakeRepositoryRoot $fake

        $env:RepositoryRoot | Should -Be $script:before.RepositoryRoot
        $env:CatzcModulesRoot | Should -Be $script:before.CatzcModulesRoot
        $fake.Root | Should -Not -Exist
    }

    It 'moves only the working root under -WorkingRootOnly, leaving the code root on the loaded modules' {
        $fake = New-FakeRepositoryRoot -WorkingRootOnly
        try {
            $env:RepositoryRoot | Should -Be $fake.Root
            $env:CatzcModulesRoot | Should -Be $script:before.CatzcModulesRoot
        }
        finally {
            Remove-FakeRepositoryRoot $fake
        }
        $env:RepositoryRoot | Should -Be $script:before.RepositoryRoot
        $env:CatzcModulesRoot | Should -Be $script:before.CatzcModulesRoot
    }

    It 'restores an unset code root as unset' {
        $env:CatzcModulesRoot = $null
        $fake = New-FakeRepositoryRoot
        $env:CatzcModulesRoot | Should -Be $fake.Automation
        Remove-FakeRepositoryRoot $fake

        $env:CatzcModulesRoot | Should -BeNullOrEmpty
    }
}
