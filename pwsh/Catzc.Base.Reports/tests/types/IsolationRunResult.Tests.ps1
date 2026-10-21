<#
---
catzc:
  immutable:
    with_body_sha: "13279de6d2a2"
  edges:
    code: pwsh/Catzc.Base.Reports/types/IsolationRunResult.cs
    cites:
      - ADR-AUTO-DEFAULT-ONERESOLUTIONORDER
      - ADR-BCL-TYPES-NATIVETYPEDMODEL
      - ADR-BCL-TYPES-CONSOLEREADYTOSTRING
---
#>

Describe 'Catzc.Base.Reports.IsolationRunResult' -Tag 'L0', 'logic', 'ADR-BCL-TYPES-NATIVETYPEDMODEL' {
    It 'holds the isolation, the sandbox, the modules and the counts, and succeeds exactly when nothing failed' {
        $result = [Catzc.Base.Reports.IsolationRunResult]::new('InProcess', 'C:/tmp/widget', [string[]] @('Catzc.Widget', 'Catzc.Gadget'), 5, 0,
            'minimal', 'C:/tmp/widget/.isolation-results.xml')
        $result.Isolation | Should -Be 'InProcess'
        $result.Sandbox | Should -Be 'C:/tmp/widget'
        $result.Modules | Should -Be @('Catzc.Widget', 'Catzc.Gadget')
        $result.Total | Should -Be 5
        $result.Failed | Should -Be 0
        $result.Success | Should -BeTrue
        $result.ModuleProfile | Should -Be 'minimal'
        $result.ResultsPath | Should -Be 'C:/tmp/widget/.isolation-results.xml'
        [Catzc.Base.Reports.IsolationRunResult]::new('Process', 'C:/tmp/gadget', $null, 5, 2).Success | Should -BeFalse
    }

    It 'declares the defaults once: no profile, no results path, no modules' -Tag 'ADR-AUTO-DEFAULT-ONERESOLUTIONORDER' {
        $result = [Catzc.Base.Reports.IsolationRunResult]::new('Process', 'C:/tmp/gadget', $null, 0, 0)
        $result.ModuleProfile | Should -BeNullOrEmpty
        $result.ResultsPath | Should -BeNullOrEmpty
        $result.Modules.Count | Should -Be 0
    }

    It 'rejects an unknown isolation, a missing sandbox and a negative total' {
        { [Catzc.Base.Reports.IsolationRunResult]::new('Thread', 'C:/tmp/widget', $null, 0, 0) } | Should -Throw '*Process or InProcess*'
        { [Catzc.Base.Reports.IsolationRunResult]::new('Process', '', $null, 0, 0) } | Should -Throw '*sandbox is required*'
        { [Catzc.Base.Reports.IsolationRunResult]::new('Process', 'C:/tmp/widget', $null, -1, 0) } | Should -Throw '*never negative*'
    }

    It 'keeps any failure count, the exit code of a Process run with no results file' {
        [Catzc.Base.Reports.IsolationRunResult]::new('Process', 'C:/tmp/widget', $null, 0, 3).Failed | Should -Be 3
        [Catzc.Base.Reports.IsolationRunResult]::new('Process', 'C:/tmp/widget', $null, 0, -1).Success | Should -BeFalse
    }

    It 'renders console-ready text' -Tag 'ADR-BCL-TYPES-CONSOLEREADYTOSTRING' {
        [Catzc.Base.Reports.IsolationRunResult]::new('Process', 'C:/tmp/widget', $null, 3, 0).ToString() | Should -Match 'Process'
    }
}
