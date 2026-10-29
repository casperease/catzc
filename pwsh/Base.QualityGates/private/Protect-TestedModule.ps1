function Protect-TestedModule {
    [CmdletBinding()]
    param(
        [AllowEmptyCollection()]
        [string[]] $Candidates = @(),

        [AllowEmptyCollection()]
        [object[]] $Rows = @(),

        [AllowEmptyCollection()]
        [string[]] $FailedShardLabels = @(),

        [Parameter(Mandatory)]
        [string] $ProtectionKey
    )

    if ($Candidates.Count -eq 0) {
        return
    }

    $failedModules = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::Ordinal)
    $modulesWithRows = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::Ordinal)
    $failedRowCount = 0
    # One module lookup per file, not per row: a file holds many rows, and each lookup resolves the modules root again.
    $moduleOfFile = [System.Collections.Generic.Dictionary[string, string]]::new([System.StringComparer]::OrdinalIgnoreCase)
    foreach ($row in $Rows) {
        if ($row.File -and -not $moduleOfFile.ContainsKey($row.File)) {
            $moduleOfFile[$row.File] = Get-TestFileModule $row.File
        }
        if ($row.File) {
            [void]$modulesWithRows.Add($moduleOfFile[$row.File])
        }
        if ($row.Result -ne 'Failed') {
            continue
        }
        $failedRowCount++
        if ($row.File) {
            [void]$failedModules.Add($moduleOfFile[$row.File])
        }
        else {
            # a failed row with no file cannot be attributed — promote nothing
            return
        }
    }

    if ($FailedShardLabels.Count -gt 0 -and $failedRowCount -eq 0) {
        # a shard failed without a single failed row: a container/discovery error — promote nothing
        return
    }

    foreach ($unit in $Candidates) {
        if ($modulesWithRows.Contains($unit) -and -not $failedModules.Contains($unit)) {
            Protect-GlobSet -Test $ProtectionKey -Name $unit
        }
    }
}
