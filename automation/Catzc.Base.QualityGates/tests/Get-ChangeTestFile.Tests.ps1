<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/tests/Get-ChangeTestFile.Tests.ps1
    folder: tests
    name: get-change-test-file-tests
    filetype: ps1
    kind: test
    language: powershell
    track: automation
    module: Catzc.Base.QualityGates
    moduletype: pwsh-folder
    catzc_bundle: azure
    relatives:
      page: docs/references/automation/catzc-base-qualitygates/tests/Get-ChangeTestFile.Tests.ps1.md
    adrs:
      - ADR-AUTO-TEST#3
---
#>

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

    It 'with -Module, brings in every test file of each touched module, and none for a dot folder or a file outside automation/' {
        $tests = InModuleScope Catzc.Base.QualityGates -Parameters @{ R = $script:root } {
            param($R)
            Get-ChangeTestFile -Path 'automation/Catzc.Widget/configs/widget.yml', 'automation/.internal/Get-Widget.ps1', 'docs/widget.md' -RepositoryRoot $R -Module
        }
        $tests | Should -Be @('automation/Catzc.Widget/tests/Get-Widget.Tests.ps1', 'automation/Catzc.Widget/tests/Set-Gadget.Tests.ps1', 'automation/Catzc.Widget/tests/types/Sprocket.Tests.ps1')
    }
}
