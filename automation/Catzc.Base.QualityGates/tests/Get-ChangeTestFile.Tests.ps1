# Get-ChangeTestFile over a fixture tree in $TestDrive. Neutral fixture names
# ([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
Describe 'Get-ChangeTestFile' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:root = Join-Path $TestDrive 'repo'
        foreach ($relative in 'automation/Catzc.Widget/tests/Get-Widget.Tests.ps1', 'automation/Catzc.Widget/tests/Set-Gadget.Tests.ps1',
            'automation/Catzc.Widget/tests/types/Sprocket.Tests.ps1') {
            $full = Join-Path $script:root $relative
            [void][System.IO.Directory]::CreateDirectory([System.IO.Path]::GetDirectoryName($full))
            [System.IO.File]::WriteAllText($full, '')
        }
        $script:map = {
            param([string[]] $Changed)
            InModuleScope Catzc.Base.QualityGates -Parameters @{ C = $Changed; R = $script:root } {
                param($C, $R)
                Get-ChangeTestFile -Path $C -RepositoryRoot $R
            }
        }
    }

    It 'maps a public function, a private function, and a C# type to their test files' {
        & $script:map @('automation/Catzc.Widget/Get-Widget.ps1', 'automation/Catzc.Widget/private/Set-Gadget.ps1', 'automation/Catzc.Widget/types/Sprocket.cs') |
            Should -Be @('automation/Catzc.Widget/tests/Get-Widget.Tests.ps1', 'automation/Catzc.Widget/tests/Set-Gadget.Tests.ps1', 'automation/Catzc.Widget/tests/types/Sprocket.Tests.ps1')
    }

    It 'keeps a changed test file as itself, once, even when its function changed too' {
        & $script:map @('automation/Catzc.Widget/tests/Get-Widget.Tests.ps1', 'automation/Catzc.Widget/Get-Widget.ps1') |
            Should -Be @('automation/Catzc.Widget/tests/Get-Widget.Tests.ps1')
    }

    It 'returns nothing for a function with no test file, a dot folder, or a file no convention covers' {
        @(& $script:map @('automation/Catzc.Widget/Get-Gizmo.ps1', 'automation/.internal/Get-Widget.ps1', 'docs/widget.md')) | Should -HaveCount 0
    }
}
