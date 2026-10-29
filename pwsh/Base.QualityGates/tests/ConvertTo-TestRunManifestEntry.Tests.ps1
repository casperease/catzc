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

    It 'records the shard timings and the pool offsets of a worker run' {
        $workerRun = [pscustomobject]@{
            ShardExitCodes   = [ordered]@{ 'shard-0' = 0 }
            ShardTimings     = @([ordered]@{ label = 'shard-0'; startSeconds = 1.5; endSeconds = 9.25; files = 3 })
            PoolStartSeconds = 1.234
            PoolEndSeconds   = 9.876
            DurationSeconds  = 10
            Location         = [pscustomobject]@{ Mode = 'in-place'; Root = 'C:\widget'; Snapshot = $null; KeepSandbox = $false; Holder = $null }
        }
        $entries = & $script:convert $workerRun
        $entries['shards'].Count | Should -Be 1
        $entries['shards'][0]['label'] | Should -Be 'shard-0'
        $entries['shards'][0]['endSeconds'] | Should -Be 9.25
        $entries['shards'][0]['files'] | Should -Be 3
        $entries['poolStartSeconds'] | Should -Be 1.23
        $entries['poolEndSeconds'] | Should -Be 9.88
    }

    It 'records no shards for a run without timings' {
        $entries = & $script:convert $null
        $entries.Contains('shards') | Should -BeFalse
    }

    It 'records no location for a fully protected run' {
        $workerRun = [pscustomobject]@{ Rows = @(); FailedShardLabels = @(); DurationSeconds = 0.0; Shards = @(); WorkerSummaries = @(); Location = $null }
        $entries = & $script:convert $workerRun
        $entries['shardExitCodes'].Count | Should -Be 0
        $entries.Contains('location') | Should -BeFalse
    }
}
