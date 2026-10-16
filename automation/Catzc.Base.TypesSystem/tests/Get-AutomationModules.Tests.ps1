<#
---
catzc:
  derived:
    path: automation/Catzc.Base.TypesSystem/tests/Get-AutomationModules.Tests.ps1
    kind: test
    language: powershell
    filetype: ps1
    track: automation
    module: Catzc.Base.TypesSystem
    moduletype: pwsh-folder-module
    bundle: azure
---
#>

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

    It 'defaults its root to the loaded code root via the Get-CatzcModulesRoot seam' {
        Mock Get-CatzcModulesRoot { $script:automation } -ModuleName Catzc.Base.TypesSystem
        Get-AutomationModules | Should -Be @('Alpha.Module', 'Beta.Module')
    }

    It 'throws when the automation directory is missing' {
        { Get-AutomationModules -AutomationRoot (Join-Path $TestDrive ([Guid]::NewGuid())) } | Should -Throw '*does not exist*'
    }
}
