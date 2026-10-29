Describe 'Save-TestShardDurations' -Tag 'L0', 'logic' {
    It 'returns no entries and saves nothing for a shard without its sidecar' {
        InModuleScope Catzc.Base.QualityGates {
            Mock Save-TestDurationHistory {}
            $missing = Join-Path ([System.IO.Path]::GetTempPath()) 'widget-missing-files.json'
            $result = Save-TestShardDurations -Shard @([pscustomobject]@{ Label = 'shard-0'; FilesPath = $missing }) -GreedyShardFile @{} `
                -Location ([pscustomobject]@{ Mode = 'in-place' }) -RepositoryRoot 'C:\widget' -HistoryPath 'C:\widget\durations.json'
            @($result).Count | Should -Be 0
            Should -Invoke Save-TestDurationHistory -Times 0
        }
    }
}
