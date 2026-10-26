Describe 'Get-CatzcRunMode' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:originalModulesRoot = $env:CatzcModulesRoot
        $script:originalRepositoryRoot = $env:RepositoryRoot
        $script:repositoryRoot = Join-Path $TestDrive 'widget-repo'
        [System.IO.Directory]::CreateDirectory((Join-Path $script:repositoryRoot 'pwsh')) | Out-Null
    }
    AfterAll {
        $env:CatzcModulesRoot = $script:originalModulesRoot
        $env:RepositoryRoot = $script:originalRepositoryRoot
    }
    BeforeEach {
        $env:RepositoryRoot = $script:repositoryRoot
    }

    It 'is source when the code root is the repository modules folder' {
        $env:CatzcModulesRoot = Join-Path $script:repositoryRoot 'pwsh'
        Get-CatzcRunMode | Should -Be 'source'
    }

    It 'is source when the code root anchor is not set (falls back to the repository modules folder)' {
        $env:CatzcModulesRoot = $null
        Get-CatzcRunMode | Should -Be 'source'
    }

    It 'ignores a trailing separator and letter case on the code root' {
        $env:CatzcModulesRoot = (Join-Path $script:repositoryRoot 'PWSH') + [System.IO.Path]::DirectorySeparatorChar
        Get-CatzcRunMode | Should -Be 'source'
    }

    It 'is build when the code root is anywhere else' {
        $env:CatzcModulesRoot = Join-Path $TestDrive 'out/pwsh/built/full/Catzc/6.6.666'
        Get-CatzcRunMode | Should -Be 'build'
    }
}
