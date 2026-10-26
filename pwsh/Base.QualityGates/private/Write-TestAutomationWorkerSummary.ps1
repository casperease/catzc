<#
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-quality-gates/private/Write-TestAutomationWorkerSummary.ps1.md"
  header: "generated"
---
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
    Write-Message ($rowFormat -f '#', 'worker', 'files', 'tests', 'passed', 'failed', 'skipped', 'start',
        'duration') -NoHeader

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
