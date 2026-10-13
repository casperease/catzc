Describe 'Get-TestAutomationTestFiles' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:widget = Join-Path $TestDrive 'widget/tests'
        $script:gadget = Join-Path $TestDrive 'gadget/tests'
        foreach ($relative in 'widget/tests/Set-Widget.Tests.ps1', 'widget/tests/Get-Widget.Tests.ps1',
            'widget/tests/types/WidgetRecord.Tests.ps1', 'widget/tests/assets/notes.txt', 'gadget/tests/Get-Gadget.Tests.ps1') {
            $path = Join-Path $TestDrive $relative
            [System.IO.Directory]::CreateDirectory([System.IO.Path]::GetDirectoryName($path)) | Out-Null
            [System.IO.File]::WriteAllText($path, '# fixture')
        }
        [System.IO.Directory]::CreateDirectory((Join-Path $TestDrive 'empty/tests')) | Out-Null
    }

    It 'keeps the folders'' order, sorts each folder ordinally, recurses, and skips non-test files' {
        $files = InModuleScope Catzc.Base.QualityGates -Parameters @{ P = @($script:gadget, $script:widget) } {
            param($P)
            Get-TestAutomationTestFiles -TestPath $P
        }
        $relative = @($files | ForEach-Object { [System.IO.Path]::GetRelativePath($TestDrive, $_).Replace('\', '/') })
        $relative | Should -Be @(
            'gadget/tests/Get-Gadget.Tests.ps1'
            'widget/tests/Get-Widget.Tests.ps1'
            'widget/tests/Set-Widget.Tests.ps1'
            'widget/tests/types/WidgetRecord.Tests.ps1'
        )
    }

    It 'throws when the folders hold no test file' {
        {
            InModuleScope Catzc.Base.QualityGates -Parameters @{ P = @(Join-Path $TestDrive 'empty/tests') } {
                param($P)
                Get-TestAutomationTestFiles -TestPath $P
            }
        } | Should -Throw '*No test files found*'
    }
}
