Describe 'Get-ChangeTestFile' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:root = Join-Path $TestDrive 'repo'
        Mock Get-CatzcModulesFolder -ModuleName Catzc.Base.QualityGates { 'widget-modules' }
        foreach ($relative in 'widget-modules/Catzc.Widget/tests/Get-Widget.Tests.ps1', 'widget-modules/Catzc.Widget/tests/Set-Gadget.Tests.ps1',
            'widget-modules/Catzc.Widget/tests/types/Sprocket.Tests.ps1') {
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
        & $script:map @('widget-modules/Catzc.Widget/Get-Widget.ps1', 'widget-modules/Catzc.Widget/private/Set-Gadget.ps1', 'widget-modules/Catzc.Widget/types/Sprocket.cs') |
            Should -Be @('widget-modules/Catzc.Widget/tests/Get-Widget.Tests.ps1', 'widget-modules/Catzc.Widget/tests/Set-Gadget.Tests.ps1', 'widget-modules/Catzc.Widget/tests/types/Sprocket.Tests.ps1')
    }

    It 'keeps a changed test file as itself, once, even when its function changed too' {
        & $script:map @('widget-modules/Catzc.Widget/tests/Get-Widget.Tests.ps1', 'widget-modules/Catzc.Widget/Get-Widget.ps1') |
            Should -Be @('widget-modules/Catzc.Widget/tests/Get-Widget.Tests.ps1')
    }

    It 'returns nothing for a function with no test file, a dot folder, or a file no convention covers' {
        @(& $script:map @('widget-modules/Catzc.Widget/Get-Gizmo.ps1', 'widget-modules/.internal/Get-Widget.ps1', 'docs/widget.md')) | Should -HaveCount 0
    }

    It 'with -Module, brings in every test file of each touched module, and none for a dot folder or a file outside the modules folder' {
        $tests = InModuleScope Catzc.Base.QualityGates -Parameters @{ R = $script:root } {
            param($R)
            Get-ChangeTestFile -Path 'widget-modules/Catzc.Widget/configs/widget.yml', 'widget-modules/.internal/Get-Widget.ps1', 'docs/widget.md' -RepositoryRoot $R -Module
        }
        $tests | Should -Be @('widget-modules/Catzc.Widget/tests/Get-Widget.Tests.ps1', 'widget-modules/Catzc.Widget/tests/Set-Gadget.Tests.ps1', 'widget-modules/Catzc.Widget/tests/types/Sprocket.Tests.ps1')
    }
}
