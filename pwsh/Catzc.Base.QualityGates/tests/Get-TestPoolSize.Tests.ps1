Describe 'Get-TestPoolSize' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:size = {
            param([int] $Parallel, [int] $GreedyFiles, [int] $GroupSize)
            InModuleScope Catzc.Base.QualityGates -Parameters @{ Parallel = $Parallel; GreedyFiles = $GreedyFiles; GroupSize = $GroupSize } {
                param($Parallel, $GreedyFiles, $GroupSize)
                Get-TestPoolSize -ParallelShardCount $Parallel -GreedyFileCount $GreedyFiles -GreedyGroupSize $GroupSize
            }
        }
    }

    It 'gives the greedy files slots of their own beside the parallel shards, so they start with the run' {
        & $script:size 5 16 2 | Should -Be 7
    }

    It 'never holds more greedy slots than there are greedy files' {
        & $script:size 5 1 2 | Should -Be 6
    }

    It 'holds only the parallel shards when no file is greedy' {
        & $script:size 5 0 2 | Should -Be 5
    }

    It 'holds the greedy slots alone when there is no parallel shard' {
        & $script:size 0 3 2 | Should -Be 2
    }

    It 'holds at least one slot' {
        & $script:size 0 0 2 | Should -Be 1
    }
}
