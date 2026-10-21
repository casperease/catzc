<#
---
catzc:
  immutable:
    with_body_sha: "922f061d374f"
  edges:
    docs: "[Get-RepositoryFolder.Tests.ps1.md](../../../docs/references/pwsh/catzc-base-repository/tests/Get-RepositoryFolder.Tests.ps1.md)"
    code: pwsh/Catzc.Base.Repository/Get-RepositoryFolder.ps1
    cites:
      - ADR-AUTO-TEST-DISTINCTFIXTUREIDENTITIES
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
