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

    It 'keys a bridged row by the folder its greedy shard ran, and writes the key back into the sidecar' -Tag 'ADR-AUTO-TEST-DEVBOXRUNBUDGET' {
        $plain = Join-Path $TestDrive 'files-shard-0.json'
        $bridged = Join-Path $TestDrive 'files-shard-1.json'
        [System.IO.File]::WriteAllText($plain, '[{ "File": "C:\\widget\\gadgets\\Widget\\tests\\Get-Widget.Tests.ps1", "DurationMs": 1000, "Result": "Passed", "ErrorMessage": "" }]')
        [System.IO.File]::WriteAllText($bridged, '[{ "File": "C:\\widget\\gadgets\\Widget\\assets\\Gadget.Bridge.ps1", "DurationMs": 2000, "Result": "Passed", "ErrorMessage": "" }]')

        $result = InModuleScope Catzc.Base.QualityGates -Parameters @{ Plain = $plain; Bridged = $bridged } {
            param($Plain, $Bridged)
            Mock Save-TestDurationHistory {}
            Save-TestShardDurations -Shard @([pscustomobject]@{ Label = 'shard-0'; FilesPath = $Plain }, [pscustomobject]@{ Label = 'shard-1'; FilesPath = $Bridged }) `
                -GreedyShardFile @{ 'shard-1' = 'C:\widget\bash\tests\gadget' } -Location ([pscustomobject]@{ Mode = 'in-place'; Root = 'C:\widget'; SourceRoot = 'C:\widget' }) `
                -RepositoryRoot 'C:\widget' -HistoryPath 'C:\widget\durations.json'
        }

        @($result | ForEach-Object Key) | Should -Be @('gadgets/Widget/tests/Get-Widget.Tests.ps1', 'bash/tests/gadget')
        ([System.IO.File]::ReadAllText($bridged) | ConvertFrom-Json).Key | Should -Be 'bash/tests/gadget'
        ([System.IO.File]::ReadAllText($plain) | ConvertFrom-Json).Key | Should -Be 'gadgets/Widget/tests/Get-Widget.Tests.ps1'
    }
}
