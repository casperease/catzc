Describe 'Write-EnvironmentDiagnostic' -Tag 'L0', 'logic' {
    It 'produces output' {
        $result = Write-EnvironmentDiagnostic | Out-String
        $result | Should -Not -BeNullOrEmpty
    }

    It 'includes known environment variables' {
        $result = Write-EnvironmentDiagnostic | Out-String
        $result | Should -Match 'PATH'
    }
}
