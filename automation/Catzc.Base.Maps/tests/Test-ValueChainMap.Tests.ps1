<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Maps/tests/Test-ValueChainMap.Tests.ps1
    kind: pester-test
    adrs:
      - ADR-AUTO-TEST#3
      - ADR-AUTO-TEST#35
      - ADR-DSGN-TRACK#14
      - ADR-DSGN-TRACK#15
      - ADR-DSGN-TRACK#16
---
#>

# Test-ValueChainMap reads the value-chain map Get-ValueChainMap returns and reports axes that are not the registry's...
# [comment:1](/docs/references/automation/catzc-base-maps/tests/Test-ValueChainMap.Tests.ps1.md#comment1)
Describe 'Test-ValueChainMap' -Tag 'L0', 'logic' {
    BeforeAll {
        $adr = {
            param([string] $External, [string] $Stack, [string[]] $Concerns)
            [Catzc.Base.Docs.AdrRuleSet]::new('widgetry', 'fixture', 'widget', $External, 'WIDGET', 'WIDGET', $null, $Stack, $Concerns, $Concerns)
        }
        $stacks = @([Catzc.Base.Docs.AdrsConfig]::Stacks)
        $concerns = @([Catzc.Base.Docs.AdrsConfig]::Concerns)
        $script:cleanMap = [Catzc.Base.Maps.ValueChainMap]::Build($stacks, $concerns, @(
                & $adr 'ADR-WIDGET-GADGET' $stacks[0] @($concerns[0], $concerns[1])
                & $adr 'ADR-WIDGET-COG' $stacks[1] @($concerns[1])
            ))
        $script:brokenMap = [Catzc.Base.Maps.ValueChainMap]::Build(@('TOP', 'BOTTOM'), @('alpha'), @(
                & $adr 'ADR-WIDGET-GADGET' 'TOP' @('alpha')
                & $adr 'ADR-WIDGET-COG' 'MIDDLE' @('alpha')
            ))
        $script:fullGlossary = @(foreach ($term in 'widget', 'gadget box', 'sprocket') {
                [pscustomobject]@{ Concept = [pscustomobject]@{ term = $term } }
            })
    }

    BeforeEach {
        Mock Write-Message -ModuleName Catzc.Base.Reports { }
        $script:map = $script:cleanMap
        $script:labels = [pscustomobject]@{
            row_axis                 = 'Gizmo'
            value_chain_row_axis     = 'Widgets'
            value_chain_column_axis  = 'Gadget box: the columns'
            value_chain_legend_title = 'Sprocket'
        }
        Mock Get-ValueChainMap -ModuleName Catzc.Base.Maps { $script:map }
        Mock Get-Glossary -ModuleName Catzc.Base.Maps { , $script:fullGlossary }
        Mock Get-Config -ModuleName Catzc.Base.Maps -ParameterFilter { $Config -eq 'maps' } { [pscustomobject]@{ labels = $script:labels } }
        $script:out = Join-Path $TestDrive ([guid]::NewGuid().ToString('n'))
    }

    It 'passes a clean map, checks only the value_chain_ labels, and reports its facts' -Tag 'ADR-AUTO-TEST#35' {
        { Test-ValueChainMap -OutputFolder $script:out } | Should -Not -Throw
        $result = Test-ValueChainMap -OutputFolder $script:out -PassThru
        $result.Subject | Should -Be 'value-chain-map'
        $result.IssueCount | Should -Be 0
        $result.Adrs | Should -Be 2
        $result.Rows | Should -Be ([Catzc.Base.Docs.AdrsConfig]::Stacks.Count)
        $result.Columns | Should -Be ([Catzc.Base.Docs.AdrsConfig]::Concerns.Count)
        $result.NonEmptyCells | Should -Be 3
        $result.Labels | Should -Be 3
    }

    It 'reports axes that are not the registry''s closed sets, a stray row, and an ADR in no cell' -Tag 'ADR-DSGN-TRACK#14', 'ADR-DSGN-TRACK#15' {
        $script:map = $script:brokenMap
        $issues = @((Test-ValueChainMap -OutputFolder $script:out -PassThru).Issues)
        $issues | Should -Be @(
            "axis: the map prints the rows TOP, BOTTOM, but the rows of the value-chain stack are $([Catzc.Base.Docs.AdrsConfig]::Stacks -join ', '), in that order (ADR-DSGN-TRACK#14)"
            "axis: the map prints the columns alpha, but the value-chain concerns are $([Catzc.Base.Docs.AdrsConfig]::Concerns -join ', '), in that order (ADR-DSGN-TRACK#15)"
            "stray value: ADR-WIDGET-COG: 'MIDDLE' is not a row of the value-chain stack (TOP, BOTTOM) (ADR-DSGN-TRACK#15)"
            'unplaced ADR: ADR-WIDGET-COG sits in no cell of the value-chain map (ADR-DSGN-TRACK#15)'
        )
    }

    It 'reports a value_chain_ label whose head names no glossary term' -Tag 'ADR-DSGN-TRACK#16' {
        $script:labels = [pscustomobject]@{ value_chain_row_axis = 'Widgets'; value_chain_title = 'Gizmo map: widgets' }
        $issues = @((Test-ValueChainMap -OutputFolder $script:out -PassThru).Issues)
        $issues | Should -Be @("unregistered label: maps.yml labels.value_chain_title 'Gizmo map: widgets' names no glossary term in its head (ADR-DSGN-TRACK#16)")
    }

    It 'throws once listing every issue without -PassThru' -Tag 'ADR-AUTO-TEST#35' {
        $script:map = $script:brokenMap
        $thrown = { Test-ValueChainMap -OutputFolder $script:out } | Should -Throw -PassThru
        $thrown.Exception.Message | Should -BeLike 'Test-ValueChainMap failed: 4 issue(s)*'
    }

    It 'writes the report to its folder and points latest.txt at it' -Tag 'ADR-AUTO-TEST#35' {
        $result = Test-ValueChainMap -OutputFolder $script:out -PassThru
        Test-Path -LiteralPath (Join-Path $result.ReportPath 'value-chain-map.md') | Should -BeTrue
        (Get-Content -LiteralPath (Join-Path $script:out 'latest.txt') -Raw).Trim() | Should -Be (Split-Path $result.ReportPath -Leaf)
    }
}

# The registry's own value-chain map, through the quality gate.
# [comment:2](/docs/references/automation/catzc-base-maps/tests/Test-ValueChainMap.Tests.ps1.md#comment2)
Describe 'Test-ValueChainMap on the repository' -Tag 'L1', 'integrity', 'source-only' {
    It 'Test-ValueChainMap passes over the registry' -Tag 'ADR-DSGN-TRACK#14', 'ADR-DSGN-TRACK#15', 'ADR-DSGN-TRACK#16', 'ADR-AUTO-TEST#35' {
        $result = Test-ValueChainMap -PassThru -OutputFolder (Join-Path $TestDrive 'value-chain-map')
        $result.IssueCount | Should -Be 0 -Because ($result.Issues -join "`n")
    }
}
