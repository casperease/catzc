<#
---
catzc:
  immutable:
    with_body_sha: "3d46135190d7"
  edges:
    docs: "[Get-RepositoryFile.Tests.ps1.md](docs/references/pwsh/catzc-base-repository/tests/Get-RepositoryFile.Tests.ps1.md)"
    code: pwsh/Catzc.Base.Repository/Get-RepositoryFile.ps1
    cites:
      - ADR-AUTO-TEST-DISTINCTFIXTUREIDENTITIES
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
