Describe 'Get-RepositoryRoot' -Tag 'L0', 'integrity' {
    It 'returns the repository root path' {
        Get-RepositoryRoot | Should -Be $env:RepositoryRoot
    }

    It 'returns a path that exists' {
        Get-RepositoryRoot | Should -Not -BeNullOrEmpty
        Test-Path (Get-RepositoryRoot) | Should -BeTrue
    }
}
