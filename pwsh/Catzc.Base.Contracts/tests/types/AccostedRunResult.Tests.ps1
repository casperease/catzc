<#
---
catzc:
  immutable:
    with_body_sha: "2348631d3484"
  edges:
    code: pwsh/Catzc.Base.Contracts/types/AccostedRunResult.cs
---
#>

Describe 'AccostedRunResult' -Tag 'L0', 'logic' {
    It 'passes exactly when the engine exited 0' {
        [Catzc.Base.Contracts.AccostedRunResult]::new(1, 'bash', 0, 'cats get-widget', 'widget').Passed | Should -BeTrue
        [Catzc.Base.Contracts.AccostedRunResult]::new(2, 'bash', 3, 'cats get-widget', 'gadget broke').Passed | Should -BeFalse
    }

    It 'fails a run whose engine never started, keeping why' {
        $result = [Catzc.Base.Contracts.AccostedRunResult]::new(1, 'zsh', $null, 'cats get-widget', 'The zsh engine was not found.')
        $result.Passed | Should -BeFalse
        $result.ExitCode | Should -BeNullOrEmpty
        $result.Output | Should -Be 'The zsh engine was not found.'
    }
}
