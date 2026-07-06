<#
.SYNOPSIS
    Promotes protection for every candidate unit that came back green from a Test-Automation run.
.DESCRIPTION
    Per-module attribution over the aggregated rows (ADR-PROTGLOB:9): a unit is promoted exactly when it
    produced at least one row and none of its rows failed. The rows-present guard is what makes a
    failed-but-completed shard safe to attribute around: a worker exits 1 when it CONTAINS failing tests
    (their rows name their files precisely), while a unit whose shard died before producing rows yields no
    rows and is never promoted. Two cases promote nothing at all: a failed shard with zero failed rows
    anywhere (a container/discovery error — nothing is attributable) and a failed row with no file. The
    identity promoted is the pending pre-run value (ADR-PROTGLOB:4); in a pipeline Protect-GlobSet is a
    no-op anyway.
.PARAMETER Candidates
    The units Select-ProtectedTestFile queried and found unprotected — the only ones with a pending identity.
.PARAMETER Rows
    The run's aggregated per-test rows.
.PARAMETER FailedShardLabels
    Labels of worker shards that exited 1.
.PARAMETER ProtectionKey
    The run-parameter key the candidates were queried under.
#>
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
    foreach ($row in $Rows) {
        if ($row.File) {
            [void]$modulesWithRows.Add((Get-TestFileModule $row.File))
        }
        if ($row.Result -ne 'Failed') {
            continue
        }
        $failedRowCount++
        if ($row.File) {
            [void]$failedModules.Add((Get-TestFileModule $row.File))
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
