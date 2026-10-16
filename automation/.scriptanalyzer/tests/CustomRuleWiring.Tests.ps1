<#
---
catzc:
  derived:
    path: automation/.scriptanalyzer/tests/CustomRuleWiring.Tests.ps1
    kind: test
    language: powershell
    filekind: ps1
    track: automation
    relatives:
      page: docs/references/automation/scriptanalyzer/tests/CustomRuleWiring.Tests.ps1.md
---
#>

[Diagnostics.CodeAnalysis.SuppressMessageAttribute('Measure-NoRawVsoCommand', '', Justification = 'Fixture intentionally contains a raw ##vso[task.*] string to prove the rule fires through the engine.')]
param()

Describe 'Custom PSScriptAnalyzer rules — engine wiring' -Tag 'L2', 'logic' {
    BeforeAll {
        if (-not (Get-Module PSScriptAnalyzer)) {
            Import-Module (Join-Path $env:RepositoryRoot 'automation/.vendor/PSScriptAnalyzer') -Force
        }
        # The shipped wiring: exactly what the settings file hands the engine.
        $settings = Import-PowerShellDataFile (Join-Path $env:RepositoryRoot 'automation/.internal/assets/PSScriptAnalyzerSettings.psd1')
        $script:rulePaths = @($settings.CustomRulePath | ForEach-Object { Join-Path $env:RepositoryRoot $_ })
        $script:analyzerSettings = @{ CustomRulePath = [string[]] $script:rulePaths; IncludeRules = [string[]] @('Measure-*') }

        $longBody = (1..301 | ForEach-Object { '    $null = 1' }) -join "`n"
        $fixture = @"
function Get-Widget { function Get-AzWidget { } }
Write-Information 'leak'
`$flag = `$env:TF_BUILD
Write-Host "##vso[task.setvariable variable=Foo]bar"
`$env:WIDGET_HOME = 'C:\widget'
`$rcg = 1
`$widget = @(Get-ChildItem)[0]
function Get-Gadget { `$script:widgetCache }
`$here = `$PWD
Write-Error 'widget'
`$succeeded = `$?
`$WidgetCount = 1
1 | ForEach-Object { return }
function Get-LongWidget {
$longBody
}
"@
        $script:records = @(Invoke-ScriptAnalyzer -ScriptDefinition $fixture -Settings $script:analyzerSettings)
        $script:firedRules = $script:records.RuleName | Sort-Object -Unique
    }

    It 'the settings hand the engine the one entry rule' {
        $script:rulePaths | Should -HaveCount 1
        Split-Path $script:rulePaths[0] -Leaf | Should -Be 'CatzcRules.psm1'
    }

    It 'PSScriptAnalyzer fires <Rule> through the entry rule, under its own rule name' -ForEach @(
        @{ Rule = 'Measure-AnnounceStateChange' }
        @{ Rule = 'Measure-NoAzModuleNaming' }
        @{ Rule = 'Measure-NoRawConsoleWrite' }
        @{ Rule = 'Measure-NoRawInformationStream' }
        @{ Rule = 'Measure-NoRawPipelineDetection' }
        @{ Rule = 'Measure-NoRawVsoCommand' }
        @{ Rule = 'Measure-SpellOutIdentifiers' }
        @{ Rule = 'Measure-NoUnsafeFirstIndex' }
        @{ Rule = 'Measure-NoBareCacheEntryRead' }
        @{ Rule = 'Measure-NeverDependOnPwd' }
        @{ Rule = 'Measure-NoWriteErrorOrWarning' }
        @{ Rule = 'Measure-NoAutomaticVariableMisuse' }
        @{ Rule = 'Measure-VariableCasing' }
        @{ Rule = 'Measure-NoForEachObjectControlFlow' }
        @{ Rule = 'Measure-FunctionLength' }
    ) {
        $script:firedRules | Should -Contain $Rule
    }

    It 'reports a violation inside a nested block once, not once per enclosing script block' {
        $nested = @($script:records | Where-Object { $_.RuleName -eq 'Measure-NoAzModuleNaming' })
        $nested | Should -HaveCount 1
    }

    It "a check's own SuppressMessageAttribute silences only that check" {
        $suppressed = @'
[Diagnostics.CodeAnalysis.SuppressMessageAttribute('Measure-NoAzModuleNaming', '', Justification = 'fixture')]
param()
function Get-AzWidget { }
Write-Error 'widget'
'@
        $fired = @(Invoke-ScriptAnalyzer -ScriptDefinition $suppressed -Settings $script:analyzerSettings).RuleName
        $fired | Should -Not -Contain 'Measure-NoAzModuleNaming'
        $fired | Should -Contain 'Measure-NoWriteErrorOrWarning'
    }
}
