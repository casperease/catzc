<#
---
catzc:
  immutable:
    with_body_sha: f5772fe046f7
  edges:
    code: pwsh/Catzc.Base.Reports/types/TestRunResult.cs
    cites:
      - ADR-AUTO-DEFAULT-ONERESOLUTIONORDER
      - ADR-BCL-TYPES-NATIVETYPEDMODEL
      - ADR-BCL-TYPES-CONSOLEREADYTOSTRING
---
#>

Describe 'Catzc.Base.Reports.TestRunResult' -Tag 'L0', 'logic', 'ADR-BCL-TYPES-NATIVETYPEDMODEL' {
    It 'holds the counts, the rows, the shards and the run directory, and counts the rows as the total' {
        $rows = @([pscustomobject]@{ Name = 'widget spins'; Result = 'Passed' }, [pscustomobject]@{ Name = 'gadget turns'; Result = 'Failed' })
        $shards = @([pscustomobject]@{ Index = 0 })
        $result = [Catzc.Base.Reports.TestRunResult]::new('Failed', 1, 1, 0, 0, 1.25, 'out/test-widget/1', [object[]] $rows, [object[]] $shards,
            [string[]] @('Catzc.Widget'), [object[]] @([pscustomobject]@{ ExpandedPath = 'Widget.reads files' }))
        $result.Result | Should -Be 'Failed'
        $result.TotalCount | Should -Be 2
        $result.PassedCount | Should -Be 1
        $result.FailedCount | Should -Be 1
        $result.SkippedCount | Should -Be 0
        $result.NotRunCount | Should -Be 0
        $result.DurationSeconds | Should -Be 1.25
        $result.RunDirectory | Should -Be 'out/test-widget/1'
        @($result.Rows.Name) | Should -Be @('widget spins', 'gadget turns')
        $result.Shards.Count | Should -Be 1
        $result.ProtectedModules | Should -Be @('Catzc.Widget')
        @($result.ExcludedTests.ExpandedPath) | Should -Be @('Widget.reads files')
    }

    It 'declares the defaults once: no rows, no shards, no protected modules, no excluded tests' -Tag 'ADR-AUTO-DEFAULT-ONERESOLUTIONORDER' {
        $result = [Catzc.Base.Reports.TestRunResult]::new('Passed', 0, 0, 0, 0, 0.0, $null)
        $result.TotalCount | Should -Be 0
        $result.Rows.Count | Should -Be 0
        $result.Shards.Count | Should -Be 0
        $result.ProtectedModules.Count | Should -Be 0
        $result.ExcludedTests.Count | Should -Be 0
        $result.RunDirectory | Should -Be ''
    }

    It 'keeps its lists read-only' {
        $result = [Catzc.Base.Reports.TestRunResult]::new('Passed', 0, 0, 0, 0, 0.0, '')
        { $result.Rows.Add('widget') } | Should -Throw
        { $result.ProtectedModules.Add('gadget') } | Should -Throw
    }

    It 'takes Passed or Failed as its result and no negative count' {
        { [Catzc.Base.Reports.TestRunResult]::new('Spinning', 0, 0, 0, 0, 0.0, '') } | Should -Throw '*Passed or Failed*'
        { [Catzc.Base.Reports.TestRunResult]::new('Passed', -1, 0, 0, 0, 0.0, '') } | Should -Throw '*never negative*'
    }

    It 'renders console-ready text' -Tag 'ADR-BCL-TYPES-CONSOLEREADYTOSTRING' {
        [Catzc.Base.Reports.TestRunResult]::new('Passed', 3, 0, 0, 0, 2.5, '').ToString() | Should -Match 'Passed'
    }
}
