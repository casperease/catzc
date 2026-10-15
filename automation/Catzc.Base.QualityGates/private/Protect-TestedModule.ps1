<#
.SYNOPSIS
    Promotes protection for every candidate unit that came back green from a Test-Automation run.
.DESCRIPTION
    Per-module attribution over the aggregated rows: a unit is promoted exactly when it produced at least one row and...
    [ADR-REPO-PROTGLOB#9](/docs/adr/repository/protected-globs.md#rule-adr-repo-protglob9),
    [ADR-REPO-PROTGLOB#4](/docs/adr/repository/protected-globs.md#rule-adr-repo-protglob4)
    [comment:1](/docs/references/automation/catzc-base-qualitygates/private/Protect-TestedModule.ps1.md#comment1)
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
