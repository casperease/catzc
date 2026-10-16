<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/.scriptanalyzer/tests/NoOneLineHashtableIfElse.Tests.ps1
    folder: automation/.scriptanalyzer/tests
    name: no-one-line-hashtable-if-else-tests
    filetype: ps1
    kind: test
    language: powershell
    track: automation
    tracktype: modules
  edges:
    cites:
      - ADR-PWSH-FORMAT#10
---
#>

Describe 'Measure-NoOneLineHashtableIfElse' -Tag 'L0', 'logic', 'ADR-PWSH-FORMAT#10' {
    BeforeAll {
        Import-Module (Join-Path $env:RepositoryRoot 'automation/.scriptanalyzer/NoOneLineHashtableIfElse.psm1') -Force
        # The rule's return type ([DiagnosticRecord]) lives in the PSScriptAnalyzer assembly.
        if (-not (Get-Module PSScriptAnalyzer)) {
            Import-Module (Join-Path $env:RepositoryRoot 'automation/.vendor/PSScriptAnalyzer') -Force
        }

        function Test-HashtableCode {
            param([string] $Code)
            $ast = [System.Management.Automation.Language.Parser]::ParseInput($Code, [ref]$null, [ref]$null)
            Measure-NoOneLineHashtableIfElse -ScriptBlockAst $ast
        }
    }

    It 'flags an if/else inside a one-line hashtable: <Code>' -ForEach @(
        @{ Code = '$fact = @{ Name = $(if ($widget) { $widget } else { ''gadget'' }) }' }
        @{ Code = '$fact = [ordered]@{ Name = $(if ($widget) { $widget } else { ''gadget'' }) }' }
        @{ Code = '$fact = @{ Name = if ($widget) { $widget } else { ''gadget'' } }' }
    ) {
        $records = @(Test-HashtableCode $Code)
        $records | Should -HaveCount 1
        $records[0].RuleName | Should -Be 'Measure-NoOneLineHashtableIfElse'
    }

    It 'flags a one-line hashtable inside another once' {
        @(Test-HashtableCode '$fact = @{ Outer = @{ Name = if ($widget) { 1 } else { 2 } } }') | Should -HaveCount 1
    }

    It 'accepts a hashtable the formatter reads: <Code>' -ForEach @(
        @{ Code = '$fact = @{ Name = $(if ($widget) { $widget }) }' }                          # an if without an else
        @{ Code = '$fact = @{ Name = $widget }' }                                              # no if at all
        @{ Code = "`$fact = @{`n    Name = `$(if (`$widget) { `$widget } else { 'gadget' })`n}" }  # several lines
        @{ Code = "`$value = if (`$widget) { `$widget } else { 'gadget' }`n`$fact = @{ Name = `$value }" }  # the sanctioned form
    ) {
        Test-HashtableCode $Code | Should -BeNullOrEmpty
    }
}
