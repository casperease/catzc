<#
---
catzc:
  immutable:
    path: automation/Catzc.Base.QualityGates/tests/ConvertTo-TestRunManifestEntry.Tests.ps1
    folder: tests
    name: convert-to-test-run-manifest-entry-tests
    filetype: ps1
    kind: test
    language: powershell
    track: automation
    module: Catzc.Base.QualityGates
    moduletype: pwsh-folder
    catzc_bundle: azure
---
#>

Describe 'ConvertTo-TestRunManifestEntry' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:convert = {
            param($WorkerRun)
            InModuleScope Catzc.Base.QualityGates -Parameters @{ W = $WorkerRun } { param($W) ConvertTo-TestRunManifestEntry -WorkerRun $W }
        }
    }

    It 'records no exit codes, a zero duration, and no location for a run without a worker run' {
        $entries = & $script:convert $null
        $entries['shardExitCodes'].Count | Should -Be 0
        $entries['durationSeconds'] | Should -Be 0
        $entries.Contains('location') | Should -BeFalse
    }

    It 'records the exit codes, the rounded duration, and the location of a worker run' {
        $workerRun = [pscustomobject]@{
            ShardExitCodes  = [ordered]@{ 'shard-0' = 0; 'shard-1' = 1 }
            DurationSeconds = 12.3456
            Location        = [pscustomobject]@{ Mode = 'in-place'; Root = 'C:\widget'; Snapshot = $null; KeepSandbox = $false; Holder = $null }
        }
        $entries = & $script:convert $workerRun
        $entries['shardExitCodes']['shard-1'] | Should -Be 1
        $entries['durationSeconds'] | Should -Be 12.35
        $entries['location'] | Should -Be 'in-place'
    }

    It 'records no location for a fully protected run' {
        $workerRun = [pscustomobject]@{ Rows = @(); FailedShardLabels = @(); DurationSeconds = 0.0; Shards = @(); WorkerSummaries = @(); Location = $null }
        $entries = & $script:convert $workerRun
        $entries['shardExitCodes'].Count | Should -Be 0
        $entries.Contains('location') | Should -BeFalse
    }
}
