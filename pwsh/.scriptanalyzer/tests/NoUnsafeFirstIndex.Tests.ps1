<#
---
catzc:
  immutable:
    with_body_sha: c4f1602c0b19
  edges:
    docs: "[NoUnsafeFirstIndex.Tests.ps1.md](../../../docs/references/pwsh/scriptanalyzer/tests/NoUnsafeFirstIndex.Tests.ps1.md)"
    cites:
      - ADR-PWSH-ERROR-STRICTCLEAN
---
#>

Describe 'Measure-NoUnsafeFirstIndex' -Tag 'L0', 'logic', 'ADR-PWSH-ERROR-STRICTCLEAN' {
    BeforeAll {
        Import-Module (Join-Path (Get-CatzcModulesRoot) '.scriptanalyzer/NoUnsafeFirstIndex.psm1') -Force
        # The rule's return type ([DiagnosticRecord]) lives in the PSScriptAnalyzer assembly.
        if (-not (Get-Module PSScriptAnalyzer)) {
            Import-Module (Join-Path (Get-CatzcModulesRoot) '.vendor/PSScriptAnalyzer') -Force
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
