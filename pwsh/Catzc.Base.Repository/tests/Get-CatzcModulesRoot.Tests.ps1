<#
---
catzc:
  immutable:
    with_body_sha: "2297965747eb"
  edges:
    code: pwsh/Catzc.Base.Repository/Get-CatzcModulesRoot.ps1
---
#>

Describe 'Get-CatzcModulesRoot' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:originalModulesRoot = $env:CatzcModulesRoot
    }
    AfterAll {
        $env:CatzcModulesRoot = $script:originalModulesRoot
    }

    Context 'anchor is set' {
        It 'returns $env:CatzcModulesRoot verbatim' {
            $env:CatzcModulesRoot = $TestDrive
            Get-CatzcModulesRoot | Should -Be $TestDrive
        }
    }

    Context 'anchor is not set' {
        It 'falls back to pwsh/ under the repository root' {
            $env:CatzcModulesRoot = $null
            $expected = Join-Path (Get-RepositoryRoot) 'pwsh'
            Get-CatzcModulesRoot | Should -Be $expected
        }
    }
}
