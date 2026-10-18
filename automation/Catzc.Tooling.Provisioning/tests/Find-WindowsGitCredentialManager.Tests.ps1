Describe 'Find-WindowsGitCredentialManager' -Tag 'L0', 'logic' {
    It 'returns the first candidate path that exists' {
        InModuleScope Catzc.Tooling.Provisioning {
            Mock Test-Path { $Path -like '*/libexec/git-core/git-credential-manager.exe' }
            Find-WindowsGitCredentialManager | Should -Be '/mnt/c/Program Files/Git/mingw64/libexec/git-core/git-credential-manager.exe'
        }
    }

    It 'returns nothing when no Windows-side install exists' {
        InModuleScope Catzc.Tooling.Provisioning {
            Mock Test-Path { $false }
            Find-WindowsGitCredentialManager | Should -BeNullOrEmpty
        }
    }
}
