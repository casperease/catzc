<#
---
catzc:
  derived:
    path: automation/Catzc.Azure.DevOps/tests/Get-AdoRepositoryName.Tests.ps1
    kind: test
    language: powershell
    filekind: ps1
    track: automation
    module: Catzc.Azure.DevOps
    relatives:
      source: automation/Catzc.Azure.DevOps/Get-AdoRepositoryName.ps1
    adrs:
      - ADR-PWSH-PARAM#4
---
#>

Describe 'Get-AdoRepositoryName' -Tag 'L0', 'logic', 'ADR-PWSH-PARAM#4' {
    BeforeEach {
        $script:originalName = $env:BUILD_REPOSITORY_NAME
        $env:BUILD_REPOSITORY_NAME = $null
        Mock Get-RepositoryRoot { Join-Path $TestDrive 'widget-repository' } -ModuleName Catzc.Azure.DevOps
    }

    AfterEach {
        $env:BUILD_REPOSITORY_NAME = $script:originalName
    }

    It 'is the pipeline agent''s repository in a pipeline' {
        $env:BUILD_REPOSITORY_NAME = 'gadget-repository'
        Get-AdoRepositoryName | Should -Be 'gadget-repository'
    }

    It 'is the checkout folder''s name on a devbox' {
        Get-AdoRepositoryName | Should -Be 'widget-repository'
    }
}
