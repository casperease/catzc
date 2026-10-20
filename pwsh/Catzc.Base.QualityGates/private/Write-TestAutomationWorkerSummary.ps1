<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.QualityGates/private/Write-TestAutomationWorkerSummary.ps1
    folder: private
    name: write-test-automation-worker-summary
    filetype: ps1
    role: function
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Base.QualityGates
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: private
  edges:
    test: pwsh/Catzc.Base.QualityGates/tests/Write-TestAutomationWorkerSummary.Tests.ps1
    docs: "[Write-TestAutomationWorkerSummary.ps1.md](docs/references/pwsh/catzc-base-qualitygates/private/Write-TestAutomationWorkerSummary.ps1.md)"
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
