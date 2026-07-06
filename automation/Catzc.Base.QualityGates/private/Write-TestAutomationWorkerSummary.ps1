<#
.SYNOPSIS
    Writes the end-of-run worker table — one row per worker, on the run's wall-clock timeline.
.DESCRIPTION
    Renders a framed section (Write-Header / Write-Footer) with one table row per worker, ordered by each
    worker's wall-clock start time (queue number — the submission order — stays visible in the # column,
    so a pool that starts workers out of order still reads truthfully). Each row carries the worker's file
    and test tallies, its start offset on the run's single timeline, and its own wall-clock duration. The
    footer line sums the tallies and names the run's total wall clock — the parallel phases mean the
    workers' durations add up to more than the run took, so the summation is printed as its own row rather
    than implied.
.PARAMETER WorkerSummaries
    The per-worker summary objects from Invoke-TestAutomationWorkers (QueueNumber, Label, Files, Tests,
    Passed, Failed, Skipped, StartSeconds, DurationSeconds).
.PARAMETER DurationSeconds
    The run's total wall clock across both phases, for the summation row.
#>
function Write-TestAutomationWorkerSummary {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [AllowEmptyCollection()]
        [object[]] $WorkerSummaries,

        [Parameter(Mandatory)]
        [double] $DurationSeconds
    )

    if ($WorkerSummaries.Count -eq 0) {
        return
    }

    $rowFormat = '{0,3}  {1,-18} {2,6} {3,6} {4,7} {5,7} {6,8} {7,9} {8,10}'

    Write-Message '' -NoHeader
    Write-Header 'Workers' -ForegroundColor Cyan
    Write-Message ($rowFormat -f '#', 'worker', 'files', 'tests', 'passed', 'failed', 'skipped', 'start', 'duration') -NoHeader

    foreach ($summary in ($WorkerSummaries | Sort-Object StartSeconds, QueueNumber)) {
        $color = if ($summary.Failed -gt 0) {
            @{ ForegroundColor = 'Red' }
        }
        else {
            @{}
        }
        Write-Message ($rowFormat -f $summary.QueueNumber, $summary.Label, $summary.Files, $summary.Tests,
            $summary.Passed, $summary.Failed, $summary.Skipped,
            ('{0:N1}s' -f $summary.StartSeconds), ('{0:N1}s' -f $summary.DurationSeconds)) -NoHeader @color
    }

    $measured = $WorkerSummaries | Measure-Object -Sum Files, Tests, Passed, Failed, Skipped, DurationSeconds
    $sums = @{}
    foreach ($m in $measured) {
        $sums[$m.Property] = $m.Sum
    }
    Write-Message ($rowFormat -f '', "$($WorkerSummaries.Count) worker(s)", $sums['Files'], $sums['Tests'],
        $sums['Passed'], $sums['Failed'], $sums['Skipped'], '',
        ('{0:N1}s' -f $sums['DurationSeconds'])) -NoHeader -ForegroundColor Cyan
    Write-Message ('Wall clock: {0:N1}s across both phases' -f $DurationSeconds) -NoHeader -ForegroundColor Cyan
    Write-Footer -ForegroundColor Cyan
}
