<#
---
catzc:
  immutable:
    path: automation/Catzc.Base.Repository/tests/Get-RepositoryFolder.Tests.ps1
    folder: tests
    name: get-repository-folder-tests
    filetype: ps1
    kind: test
    language: powershell
    track: automation
    module: Catzc.Base.Repository
    moduletype: pwsh-folder
    catzc_bundle: azure
  edges:
    page: docs/references/automation/catzc-base-repository/tests/Get-RepositoryFolder.Tests.ps1.md
    cites:
      - ADR-AUTO-TEST#3
---
#>

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
