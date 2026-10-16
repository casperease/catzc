<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/tests/Test-TestTitles.Tests.ps1
    kind: test
    language: powershell
    filekind: ps1
    track: automation
    module: Catzc.Base.QualityGates
    relatives:
      page: docs/references/automation/catzc-base-qualitygates/tests/Test-TestTitles.Tests.ps1.md
      source: automation/Catzc.Base.QualityGates/Test-TestTitles.ps1
    adrs:
      - ADR-AUTO-TEST#3
---
#>

Describe 'Test-TestTitles' -Tag 'L0', 'logic' {
    BeforeAll {
        function Set-FixtureFile {
            param([string] $Path, [string[]] $Line)
            $full = Join-Path $TestDrive "repo/automation/$Path"
            [void][System.IO.Directory]::CreateDirectory([System.IO.Path]::GetDirectoryName($full))
            [System.IO.File]::WriteAllText($full, ($Line -join "`n"))
        }
        $script:token = '<' + 'name' + '>'
    }

    BeforeEach {
        Remove-Item (Join-Path $TestDrive 'repo') -Recurse -Force -ErrorAction Ignore
        Mock Get-RepositoryRoot -ModuleName Catzc.Base.QualityGates { Join-Path $TestDrive 'repo' }
        Mock Write-Message -ModuleName Catzc.Base.Reports { }
        Set-FixtureFile 'Widget/tests/Get-Widget.Tests.ps1' @(
            "Describe 'Get-Widget' {"
            "    It 'reads widget $token' -ForEach @(@{ name = 'a' }) { }"
            "    It 'reads gadget $token' -TestCases @(@{ name = 'b' }) { }"
            "    It 'reads plain titles' { }"
            '}'
        )
        Set-FixtureFile '.vendor/Tool/tests/Get-Tool.Tests.ps1' @("It 'vendored $token' { }")
        Set-FixtureFile 'Widget/tests/Get-Broken.Tests.ps1' @("It 'broken $token' {")
        $script:out = Join-Path $TestDrive 'out'
    }

    It 'passes data-driven template titles and skips vendored and unparseable files' {
        $result = Test-TestTitles -OutputFolder $out -PassThru
        $result.IssueCount | Should -Be 0
        $result.TestFiles | Should -Be 2
    }

    It 'throws once naming every template title without data, single- or double-quoted' {
        Set-FixtureFile 'Widget/tests/Get-Gadget.Tests.ps1' @(
            "Context 'configs/$token.yml' { }"
            "It `"expands $token`" { }"
        )
        $thrown = { Test-TestTitles -OutputFolder $out } | Should -Throw -PassThru
        $message = $thrown.Exception.Message
        $message | Should -BeLike 'Test-TestTitles failed: 2 issue(s)*'
        $message | Should -Match ([regex]::Escape("automation/Widget/tests/Get-Gadget.Tests.ps1: Context 'configs/$token.yml' has a template token"))
        $message | Should -Match ([regex]::Escape("It 'expands $token' has a template token"))
    }

    It 'returns the issues under -PassThru instead of throwing' {
        Set-FixtureFile 'Widget/tests/Get-Gadget.Tests.ps1' @("Describe 'gadget $token' { }")
        $result = Test-TestTitles -OutputFolder $out -PassThru
        $result.Subject | Should -Be 'test-titles'
        $result.Issues | Should -HaveCount 1
    }
}
