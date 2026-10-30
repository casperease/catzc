function Get-TestRunOutcome {
    [CmdletBinding()]
    [OutputType([pscustomobject[]])]
    param(
        # The run's merged rows, their files already mapped to the working folder.
        [AllowEmptyCollection()]
        [object[]] $Row = @(),

        # The run's file entries (File, Result), one per test file a worker ran, mapped the same way.
        [AllowEmptyCollection()]
        [object[]] $File = @(),

        # The run's shards (Label, FilesPath, RowsPath), read for a shard that failed with no failed file or row.
        [AllowEmptyCollection()]
        [object[]] $Shard = @(),

        [AllowEmptyCollection()]
        [string[]] $FailedShardLabel = @(),

        [Parameter(Mandatory)]
        [pscustomobject] $Location
    )

    $failedByFile = @{}
    foreach ($item in $Row) {
        if ($item.Result -eq 'Failed' -and $item.PSObject.Properties['File']) {
            $failedByFile[$item.File] = [int] $failedByFile[$item.File] + 1
        }
    }
    $outcomes = [ordered]@{}
    foreach ($entry in $File) {
        if ($entry.Result -eq 'NotRun') {
            continue
        }
        $failedTests = [int] $failedByFile[$entry.File]
        $outcomes[$entry.File] = [pscustomobject]@{
            Path        = $entry.File
            Failed      = $entry.Result -eq 'Failed' -or $failedTests -gt 0
            FailedCount = $failedTests
        }
    }

    # A container error fails its shard with no failed row; every file of such a shard counts as failed, never passed.
    foreach ($item in @($Shard | Where-Object { $_.Label -in $FailedShardLabel })) {
        if (-not [System.IO.File]::Exists($item.FilesPath)) {
            continue
        }
        $shardFiles = @([System.IO.File]::ReadAllText($item.FilesPath) | ConvertFrom-Json | ForEach-Object {
                Convert-TestRunLocationPath -Location $Location -Path $_.File -ToSource
            })
        $shardOutcomes = @($shardFiles | Where-Object { $outcomes.Contains($_) } | ForEach-Object { $outcomes[$_] })
        if (@($shardOutcomes | Where-Object { $_.Failed }).Count -gt 0) {
            continue
        }
        foreach ($shardFile in $shardFiles) {
            $outcomes[$shardFile] = [pscustomobject]@{ Path = $shardFile; Failed = $true; FailedCount = 0 }
        }
    }

    [pscustomobject[]] @($outcomes.Values)
}
