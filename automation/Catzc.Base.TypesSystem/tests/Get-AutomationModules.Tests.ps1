Describe 'Get-AutomationModules' -Tag 'L0', 'logic' {
    BeforeAll {
        # Fixture automation tree: two real modules + dot-prefixed infrastructure (must be excluded).
        $script:fakeRoot = Join-Path $TestDrive ([Guid]::NewGuid())
        $script:automation = Join-Path $fakeRoot 'automation'
        foreach ($d in 'Beta.Module', 'Alpha.Module', '.internal', '.vendor', '.compiled') {
            [System.IO.Directory]::CreateDirectory((Join-Path $automation $d)) | Out-Null
        }
    }

    It 'returns only the non-dot module directories, sorted ordinally' {
        Get-AutomationModules -AutomationRoot $automation | Should -Be @('Alpha.Module', 'Beta.Module')
    }

    It 'excludes dot-prefixed infrastructure directories' {
        $names = Get-AutomationModules -AutomationRoot $automation
        $names | Should -Not -Contain '.internal'
        $names | Should -Not -Contain '.vendor'
        $names | Should -Not -Contain '.compiled'
    }

    It 'defaults its root to the repository automation folder via the Get-RepositoryRoot seam' {
        Mock Get-RepositoryRoot { $script:fakeRoot } -ModuleName Catzc.Base.TypesSystem
        Get-AutomationModules | Should -Be @('Alpha.Module', 'Beta.Module')
    }

    It 'throws when the automation directory is missing' {
        { Get-AutomationModules -AutomationRoot (Join-Path $TestDrive ([Guid]::NewGuid())) } | Should -Throw '*does not exist*'
    }
}
