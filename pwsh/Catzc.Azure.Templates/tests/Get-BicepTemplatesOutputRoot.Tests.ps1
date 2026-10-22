Describe 'Get-BicepTemplatesOutputRoot' -Tag 'L0', 'logic' {
    It 'is the repository out folder' {
        Get-BicepTemplatesOutputRoot | Should -Be (Join-Path (Get-RepositoryRoot) 'out')
    }
}
