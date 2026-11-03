Describe 'Get-CatzcModulesRoot' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:originalModulesRoot = $env:CatzcModulesRoot
        $script:originalModulesFolder = $env:CatzcModulesFolder
    }
    AfterAll {
        $env:CatzcModulesRoot = $script:originalModulesRoot
        $env:CatzcModulesFolder = $script:originalModulesFolder
    }

    Context 'anchor is set' {
        It 'returns $env:CatzcModulesRoot verbatim' {
            $env:CatzcModulesRoot = $TestDrive
            Get-CatzcModulesRoot | Should -Be $TestDrive
        }
    }

    Context 'anchor is not set' {
        It 'falls back to the modules folder under the repository root' {
            $env:CatzcModulesRoot = $null
            $env:CatzcModulesFolder = 'gadgetry'
            $expected = Join-Path (Get-RepositoryRoot) 'gadgetry'
            Get-CatzcModulesRoot | Should -Be $expected
        }

        It 'throws, naming the importer, when the modules folder variable is unset too' {
            $env:CatzcModulesRoot = $null
            $env:CatzcModulesFolder = $null
            { Get-CatzcModulesRoot } | Should -Throw '*importer*'
        }
    }
}
