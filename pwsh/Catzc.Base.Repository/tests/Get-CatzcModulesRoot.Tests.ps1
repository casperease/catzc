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
        It 'falls back to automation/ under the repository root' {
            $env:CatzcModulesRoot = $null
            $expected = Join-Path (Get-RepositoryRoot) 'automation'
            Get-CatzcModulesRoot | Should -Be $expected
        }
    }
}
