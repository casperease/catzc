# Shared wiring gate for the repo's AST-direct custom rules. Each rule's per-case behaviour is proven at L0 by
# calling the rule function directly (see the sibling <Rule>.Tests.ps1 files); the one thing those L0 tests
# cannot prove is that PSScriptAnalyzer discovers a rule via -CustomRulePath and surfaces its diagnostic when a
# real violation is present. That end-to-end fact is identical for every rule, so one invocation over a single
# fixture that trips all of them proves it once — rather than paying the engine + rule-module compile per rule.
#
# The fixture embeds a raw ##vso[task.*] string (to trip Measure-NoRawVsoCommand), which that rule would then
# flag against this file during the repo analysis gate — suppress it for the whole file, as the rule's own test
# file does.
[Diagnostics.CodeAnalysis.SuppressMessageAttribute('Measure-NoRawVsoCommand', '', Justification = 'Fixture intentionally contains a raw ##vso[task.*] string to prove the rule fires through the engine.')]
param()

Describe 'Custom PSScriptAnalyzer rules — engine wiring' -Tag 'L2', 'logic' {
    BeforeAll {
        if (-not (Get-Module PSScriptAnalyzer)) {
            Import-Module (Join-Path $env:RepositoryRoot 'automation/.vendor/PSScriptAnalyzer') -Force
        }
        $ruleNames = @(
            'NoAzModuleNaming'
            'NoRawInformationStream'
            'NoRawPipelineDetection'
            'NoRawVsoCommand'
            'SpellOutIdentifiers'
        )
        $rulePaths = $ruleNames | ForEach-Object { Join-Path $env:RepositoryRoot "automation/.scriptanalyzer/$_.psm1" }

        # One fixture that trips every rule at once: an Az-named function, a raw Write-Information, a direct
        # pipeline-detection env read, a raw ##vso command, and a coined variable name.
        $fixture = @'
function Get-AzResource { }
Write-Information 'leak'
$flag = $env:TF_BUILD
Write-Host "##vso[task.setvariable variable=Foo]bar"
$rcg = 1
'@
        $script:firedRules = @(
            Invoke-ScriptAnalyzer -ScriptDefinition $fixture -CustomRulePath $rulePaths
        ).RuleName | Sort-Object -Unique
    }

    It 'PSScriptAnalyzer discovers and fires <Rule> via -CustomRulePath' -ForEach @(
        @{ Rule = 'Measure-NoAzModuleNaming' }
        @{ Rule = 'Measure-NoRawInformationStream' }
        @{ Rule = 'Measure-NoRawPipelineDetection' }
        @{ Rule = 'Measure-NoRawVsoCommand' }
        @{ Rule = 'Measure-SpellOutIdentifiers' }
    ) {
        $script:firedRules | Should -Contain $Rule
    }
}
