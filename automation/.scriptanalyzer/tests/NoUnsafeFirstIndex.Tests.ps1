<#
---
catzc:
  derived:
    path: automation/.scriptanalyzer/tests/NoUnsafeFirstIndex.Tests.ps1
    folder: automation/.scriptanalyzer/tests
    name: no-unsafe-first-index-tests
    filetype: ps1
    kind: test
    language: powershell
    track: automation
    relatives:
      page: docs/references/automation/scriptanalyzer/tests/NoUnsafeFirstIndex.Tests.ps1.md
    adrs:
      - ADR-PWSH-ERROR#8
---
#>

Describe 'Measure-NoUnsafeFirstIndex' -Tag 'L0', 'logic', 'ADR-PWSH-ERROR#8' {
    BeforeAll {
        Import-Module (Join-Path $env:RepositoryRoot 'automation/.scriptanalyzer/NoUnsafeFirstIndex.psm1') -Force
        # The rule's return type ([DiagnosticRecord]) lives in the PSScriptAnalyzer assembly.
        if (-not (Get-Module PSScriptAnalyzer)) {
            Import-Module (Join-Path $env:RepositoryRoot 'automation/.vendor/PSScriptAnalyzer') -Force
        }

        function Test-FirstIndex {
            param([string] $Code)
            $ast = [System.Management.Automation.Language.Parser]::ParseInput($Code, [ref]$null, [ref]$null)
            Measure-NoUnsafeFirstIndex -ScriptBlockAst $ast
        }
    }

    It 'flags the first element of a collected result: <Code>' -ForEach @(
        @{ Code = '$widget = @(Get-Widget)[0]' }
        @{ Code = '$widget = @($widgets | Where-Object { $_.Ready })[0]' }
        @{ Code = '$widget = (Get-Widget | Sort-Object Name)[0]' }
    ) {
        $records = @(Test-FirstIndex $Code)
        $records | Should -HaveCount 1
        $records[0].RuleName | Should -Be 'Measure-NoUnsafeFirstIndex'
    }

    It 'flags a nested occurrence once' {
        @(Test-FirstIndex 'function Get-Gadget { foreach ($item in $items) { @($item.Keys)[0] } }') | Should -HaveCount 1
    }

    It 'accepts an index whose length the code owns: <Code>' -ForEach @(
        @{ Code = '$widget = $widgets[0]' }                                     # a variable — its length is the caller's business
        @{ Code = '$value = $Matches[0]' }                                      # a member/automatic collection
        @{ Code = '$head = ($line -split '':'')[0]' }                           # -split always yields at least one element
        @{ Code = '$head = @($line -split '':'')[0]' }                          # … also inside @()
        @{ Code = '$widget = Get-Widget | Select-Object -First 1' }             # the sanctioned form
        @{ Code = '$second = @(Get-Widget)[1]' }                                # only [0] is the first-element idiom
    ) {
        Test-FirstIndex $Code | Should -BeNullOrEmpty
    }
}
