<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Repository/tests/Get-RepositoryFolder.Tests.ps1
    kind: pester-test
---
#>

# Get-RepositoryFolder over a $TestDrive root (Get-RepositoryRoot mocked): path normalization against the root, never
# $PWD. Neutral fixture names ([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
Describe 'Get-RepositoryFolder' -Tag 'L0', 'logic' {
    BeforeEach {
        Mock Get-RepositoryRoot -ModuleName Catzc.Base.Repository { Join-Path $TestDrive 'repo' }
        $script:root = Join-Path $TestDrive 'repo'
    }

    It 'returns the normalized absolute path for a relative folder' {
        Get-RepositoryFolder 'widget/gadget' | Should -Be ([IO.Path]::GetFullPath((Join-Path $script:root 'widget/gadget')))
    }

    It 'collapses a leading dot segment instead of leaking it into the result' {
        $result = Get-RepositoryFolder './widget'
        $result | Should -Be ([IO.Path]::GetFullPath((Join-Path $script:root 'widget')))
        $result | Should -Not -Match '[\\/]\.[\\/]'
    }

    It 'collapses a parent (..) segment' {
        Get-RepositoryFolder 'widget/../gadget' | Should -Be ([IO.Path]::GetFullPath((Join-Path $script:root 'gadget')))
    }
}
