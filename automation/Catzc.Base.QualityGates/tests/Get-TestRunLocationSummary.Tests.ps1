<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/tests/Get-TestRunLocationSummary.Tests.ps1
    kind: pester-test
---
#>

Describe 'Get-TestRunLocationSummary' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:summarize = {
            param($Location)
            InModuleScope Catzc.Base.QualityGates -Parameters @{ L = $Location } { param($L) Get-TestRunLocationSummary -Location $L }
        }
    }

    It 'renders nothing for a run that executed nowhere' {
        $summary = & $script:summarize $null
        $summary.Text | Should -Be ''
        $summary.Manifest.Count | Should -Be 0
    }

    It 'renders an in-place run as its mode alone' {
        $summary = & $script:summarize ([pscustomobject]@{ Mode = 'in-place'; Root = 'C:\widget'; Snapshot = $null; KeepSandbox = $false; Holder = $null })
        $summary.Text | Should -Be 'in-place'
        $summary.Manifest['location'] | Should -Be 'in-place'
        $summary.Manifest.Contains('snapshot') | Should -BeFalse
    }

    It 'renders a snapshot run with its provenance, in the text and the manifest alike' {
        $snapshot = [pscustomobject]@{ Path = 'C:\tmp\catzc-run-gadget'; SourceRoot = 'C:\widget'; Commit = '0a69309f00d'; Modified = 7; Untracked = 2; Deleted = 0 }
        $summary = & $script:summarize ([pscustomobject]@{
                Mode = 'snapshot'; Root = $snapshot.Path; Snapshot = $snapshot; KeepSandbox = $true
                Holder = [pscustomobject]@{ Description = 'Test-Automation (pid 1)' }
            })
        $summary.Text | Should -Be 'snapshot of C:\widget @ 0a69309 + 7 modified, 2 untracked, 0 deleted file(s) in C:\tmp\catzc-run-gadget (kept)'
        $summary.Manifest['location'] | Should -Be 'snapshot'
        $summary.Manifest['snapshot']['commit'] | Should -Be '0a69309f00d'
        $summary.Manifest['snapshot']['kept'] | Should -BeTrue
        $summary.Manifest['snapshot']['holder'] | Should -Be 'Test-Automation (pid 1)'
    }
}
