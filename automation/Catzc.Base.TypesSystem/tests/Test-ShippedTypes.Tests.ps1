<#
---
catzc:
  derived:
    path: automation/Catzc.Base.TypesSystem/tests/Test-ShippedTypes.Tests.ps1
    kind: test
---
#>

# Test-ShippedTypes over a fixture code root in $TestDrive: one file named for a type the session has (System.String
# under a 'System' module folder), one named for a type that never loaded. Neutral fixture names
# ([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
Describe 'Test-ShippedTypes' -Tag 'L0', 'logic' {
    BeforeAll {
        $root = Join-Path $TestDrive 'automation'
        foreach ($path in 'System/types/String.cs', 'TstWidget/types/Gadget.cs', 'TstWidget/README.md', '.internal/types/Hidden.cs') {
            $full = Join-Path $root $path
            [void][System.IO.Directory]::CreateDirectory([System.IO.Path]::GetDirectoryName($full))
            [System.IO.File]::WriteAllText($full, '')
        }
        $script:out = Join-Path $TestDrive 'out'
    }

    BeforeEach {
        Mock Get-CatzcModulesRoot -ModuleName Catzc.Base.TypesSystem { Join-Path $TestDrive 'automation' }
        Mock Write-Message -ModuleName Catzc.Base.Reports { }
    }

    It 'throws once naming each type that does not resolve, skipping dot-folders' {
        $thrown = { Test-ShippedTypes -OutputFolder $out } | Should -Throw -PassThru
        $thrown.Exception.Message | Should -BeLike 'Test-ShippedTypes failed: 1 issue(s)*'
        $thrown.Exception.Message | Should -BeLike "*TstWidget/types/Gadget.cs: type 'TstWidget.Gadget' does not resolve after import*"
    }

    It 'returns the result and counts every type file under -PassThru' {
        $result = Test-ShippedTypes -OutputFolder $out -PassThru
        $result.Subject | Should -Be 'shipped-types'
        $result.Types | Should -Be 2
        $result.IssueCount | Should -Be 1
    }
}
