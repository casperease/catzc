# This file is covered by the analysis gate like all authored PowerShell (Get-AutomationSourceFiles). Its
# fixtures deliberately embed raw ##vso[task.*] strings so the rule can prove it flags them, which the rule
# itself would then report against this file — suppress it here for the whole file rather than mangle the
# fixtures.
[Diagnostics.CodeAnalysis.SuppressMessageAttribute('Measure-NoRawVsoCommand', '', Justification = 'Test fixtures intentionally contain raw ##vso[task.*] strings to prove the rule flags them.')]
param()

Describe 'Measure-NoRawVsoCommand' -Tag 'L2', 'logic' {
    BeforeAll {
        if (-not (Get-Module PSScriptAnalyzer)) {
            Import-Module (Join-Path $env:RepositoryRoot 'automation/.vendor/PSScriptAnalyzer') -Force
        }
        $script:rulePath = Join-Path $env:RepositoryRoot 'automation/.scriptanalyzer/NoRawVsoCommand.psm1'

        function Test-RawVso {
            param([string] $Code)
            Invoke-ScriptAnalyzer -ScriptDefinition $Code -CustomRulePath $script:rulePath |
                Where-Object RuleName -EQ 'Measure-NoRawVsoCommand'
        }
    }

    It 'flags a raw ##vso command in a script: <Desc>' -ForEach @(
        @{ Desc = 'setvariable, double quotes'; Code = 'Write-Host "##vso[task.setvariable variable=Foo]bar"' }
        @{ Desc = 'setvariable, single quotes'; Code = "Write-Output '##vso[task.setvariable variable=Foo]bar'" }
        @{ Desc = 'logissue'; Code = 'Write-Host "##vso[task.logissue type=error]boom"' }
    ) {
        Test-RawVso $Code | Should -Not -BeNullOrEmpty
    }

    It 'flags a raw ##vso command in a function other than the setter' {
        $code = @'
function Set-SomethingElse {
    Write-Host "##vso[task.setvariable variable=Foo]bar"
}
'@
        Test-RawVso $code | Should -Not -BeNullOrEmpty
    }

    It 'exempts the canonical Set-AdoPipelineVariable function' {
        $code = @'
function Set-AdoPipelineVariable {
    param([string] $Name, [string] $Value)
    Write-Host "##vso[task.setvariable variable=$Name]$Value"
}
'@
        Test-RawVso $code | Should -BeNullOrEmpty
    }

    It 'passes clean code with no ##vso strings' {
        Test-RawVso 'Set-AdoPipelineVariable -Name Foo -Value bar' | Should -BeNullOrEmpty
    }
}
