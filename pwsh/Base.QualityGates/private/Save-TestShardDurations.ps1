function Save-TestShardDurations {
    [CmdletBinding()]
    [OutputType([object[]])]
    param(
        [Parameter(Mandatory)]
        [AllowEmptyCollection()]
        [object[]] $Shard,

        [Parameter(Mandatory)]
        [hashtable] $GreedyShardFile,

        [Parameter(Mandatory)]
        [pscustomobject] $Location,

        [Parameter(Mandatory)]
        [string] $RepositoryRoot,

        [Parameter(Mandatory)]
        [string] $HistoryPath
    )

    # Each file's duration feeds the next run's dealing; a shard without its sidecar adds nothing.
    $measured = @{}
    $fileEntries = [System.Collections.Generic.List[object]]::new()
    foreach ($item in $Shard) {
        if ([System.IO.File]::Exists($item.FilesPath)) {
            $shardEntries = @([System.IO.File]::ReadAllText($item.FilesPath) | ConvertFrom-Json)
            $shardSource = if ($GreedyShardFile.ContainsKey($item.Label) -and $shardEntries.Count -eq 1) {
                Convert-TestRunLocationPath -Location $Location -Path $GreedyShardFile[$item.Label] -ToSource
            }
            else {
                ''
            }
            foreach ($entry in $shardEntries) {
                $source = Convert-TestRunLocationPath -Location $Location -Path $entry.File -ToSource
                $measured[(Get-TestDurationKey -File $source -ShardFile $shardSource -RepositoryRoot $RepositoryRoot)] = $entry.DurationMs
                $entry.File = $source
                $fileEntries.Add($entry)
            }
        }
    }
    if ($measured.Count -gt 0) {
        Save-TestDurationHistory -Path $HistoryPath -DurationMs $measured
    }
    , @($fileEntries)
}
