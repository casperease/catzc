<#
---
catzc:
  immutable:
    path: automation/Catzc.Base.Repository/tests/Get-RepositoryFile.Tests.ps1
    folder: tests
    name: get-repository-file-tests
    filetype: ps1
    kind: test
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.Repository
    moduletype: pwsh-folder
    catzc_bundle: azure
  edges:
    page: docs/references/automation/catzc-base-repository/tests/Get-RepositoryFile.Tests.ps1.md
    cites:
      - ADR-AUTO-TEST#3
---
#>

Describe 'Get-RepositoryFile' -Tag 'L0', 'logic' {
    BeforeEach {
        Mock Get-RepositoryRoot -ModuleName Catzc.Base.Repository { Join-Path $TestDrive 'repo' }
        $script:root = Join-Path $TestDrive 'repo'
    }

    It 'returns the normalized absolute path for a relative file' {
        Get-RepositoryFile 'widget.ps1' | Should -Be ([IO.Path]::GetFullPath((Join-Path $script:root 'widget.ps1')))
    }

    It 'collapses a leading dot segment instead of leaking it into the result' {
        $result = Get-RepositoryFile './widget.ps1'
        $result | Should -Be ([IO.Path]::GetFullPath((Join-Path $script:root 'widget.ps1')))
        $result | Should -Not -Match '[\\/]\.[\\/]'
    }

    It 'collapses a parent (..) segment' {
        Get-RepositoryFile 'gadget/../widget.ps1' | Should -Be ([IO.Path]::GetFullPath((Join-Path $script:root 'widget.ps1')))
    }
}
