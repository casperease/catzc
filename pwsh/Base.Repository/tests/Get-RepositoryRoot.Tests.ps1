# Get-RepositoryRoot reads $env:RepositoryRoot (set by importer.ps1); pinned against a $TestDrive root and restored.
Describe 'Get-RepositoryRoot' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:originalRepositoryRoot = $env:RepositoryRoot
    }
    AfterAll {
        $env:RepositoryRoot = $script:originalRepositoryRoot
    }

    It 'returns the repository root the importer set in $env:RepositoryRoot' {
        $env:RepositoryRoot = Join-Path $TestDrive 'widget'
        Get-RepositoryRoot | Should -Be (Join-Path $TestDrive 'widget')
    }

    It 'throws, naming importer.ps1, when $env:RepositoryRoot is unset' {
        $env:RepositoryRoot = $null
        { Get-RepositoryRoot } | Should -Throw '*importer.ps1*'
    }

    It 'throws, naming importer.ps1, when $env:RepositoryRoot is empty' {
        $env:RepositoryRoot = ''
        { Get-RepositoryRoot } | Should -Throw '*importer.ps1*'
    }
}
