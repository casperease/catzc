<#
---
catzc:
  derived:
    path: automation/Catzc.Base.RootConfig/tests/Test-RootAnalyzerSettings.Tests.ps1
    kind: pester-test
    adrs:
      - ADR-AUTO-TEST#3
---
#>

# Test-RootAnalyzerSettings over a fixture root settings file in $TestDrive with the registry entries mocked, so each...
# [comment:1](/docs/references/automation/catzc-base-rootconfig/tests/Test-RootAnalyzerSettings.Tests.ps1.md#comment1)
Describe 'Test-RootAnalyzerSettings' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:settingsPath = Join-Path $TestDrive 'repo/PSScriptAnalyzerSettings.psd1'
        $script:out = Join-Path $TestDrive 'out'
    }

    BeforeEach {
        [void][System.IO.Directory]::CreateDirectory((Join-Path $TestDrive 'repo'))
        [System.IO.File]::WriteAllText($settingsPath, "@{ ExcludeRules = @('PSAvoidWidget') }")
        Mock Get-RepositoryRoot -ModuleName Catzc.Base.RootConfig { Join-Path $TestDrive 'repo' }
        Mock Write-Message -ModuleName Catzc.Base.Reports { }
        Mock Get-Config -ModuleName Catzc.Base.RootConfig -ParameterFilter { $Config -eq 'rootconfig' } { [pscustomobject]@{} }
        Mock Get-RootConfigTargets -ModuleName Catzc.Base.RootConfig {
            [pscustomobject]@{ target = 'PSScriptAnalyzerSettings.psd1'; source = 'src/settings.psd1' }
        }
    }

    It 'passes when the root file parses as a non-empty settings hashtable' {
        $result = Test-RootAnalyzerSettings -OutputFolder $out -PassThru
        $result.IssueCount | Should -Be 0
        $result.Checked | Should -BeTrue
    }

    It 'checks nothing when the entry is not opted in' {
        Mock Get-RootConfigTargets -ModuleName Catzc.Base.RootConfig { [pscustomobject]@{ target = 'widget.json'; source = 'src/widget.json' } }
        Remove-Item $settingsPath
        $result = Test-RootAnalyzerSettings -OutputFolder $out -PassThru
        $result.IssueCount | Should -Be 0
        $result.Checked | Should -BeFalse
    }

    It 'throws when the root file does not parse' {
        [System.IO.File]::WriteAllText($settingsPath, '@{ ExcludeRules = ')
        $thrown = { Test-RootAnalyzerSettings -OutputFolder $out } | Should -Throw -PassThru
        $thrown.Exception.Message | Should -BeLike 'Test-RootAnalyzerSettings failed: 1 issue(s)*'
        $thrown.Exception.Message | Should -Match 'PSScriptAnalyzerSettings.psd1: does not parse as a settings hashtable'
    }

    It 'reports a missing root file and an empty one under -PassThru' {
        Remove-Item $settingsPath
        (Test-RootAnalyzerSettings -OutputFolder $out -PassThru).Issues | Should -Match 'missing at the repository root'

        [System.IO.File]::WriteAllText($settingsPath, '@{ }')
        $result = Test-RootAnalyzerSettings -OutputFolder $out -PassThru
        $result.Subject | Should -Be 'root-analyzer-settings'
        $result.Issues | Should -Match 'holds no settings'
    }
}
