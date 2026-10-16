<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/private/Save-TestDurationHistory.ps1
    kind: function
    language: powershell
    filetype: ps1
    track: automation
    module: Catzc.Base.QualityGates
    moduletype: pwsh-folder-module
    bundle: azure
    visibility: private
    relatives:
      test: automation/Catzc.Base.QualityGates/tests/Save-TestDurationHistory.Tests.ps1
  config:
    synopsis: Merges a run's measured per-file durations into the test duration history.
    description: |-
      Files this run did not measure keep their entries, so a partial run (one module, one tier) forgets nothing. A faster run lowers
      Each file the run measured replaces its entry; files the run did not run keep theirs, so a partial run (one
      module, one tier) never forgets the rest. The file is written sorted by path, so it diffs cleanly, and written
      only after the run's own results are safe, so a crash cannot corrupt it. See Get-TestDurationHistory.
    parameters:
      Path: The history file.
      DurationMs: This run's measurements, repository-relative '/'-separated file path -> milliseconds.
      Decay: The share of the stored duration a faster run keeps (0 up to, not including, 1); omitted reads duration_decay from test-policy.yml.
---
#>

function Save-TestDurationHistory {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string] $Path,

        [Parameter(Mandatory)]
        [System.Collections.IDictionary] $DurationMs,

        [ValidateRange(0, 0.999)]
        [double] $Decay
    )

    if (-not $PSBoundParameters.ContainsKey('Decay')) {
        $Decay = (Get-Config -Config test-policy).duration_decay
    }
    $history = Get-TestDurationHistory -Path $Path
    foreach ($key in $DurationMs.Keys) {
        $measured = [double] $DurationMs[$key]
        $kept = if ($history.Contains($key)) {
            $history[$key] * $Decay
        }
        else {
            0
        }
        $history[$key] = [Math]::Round([Math]::Max($measured, $kept))
    }
    $sorted = [ordered]@{}
    foreach ($key in @($history.Keys | Sort-Object)) {
        $sorted[$key] = $history[$key]
    }
    [System.IO.Directory]::CreateDirectory([System.IO.Path]::GetDirectoryName($Path)) | Out-Null
    [System.IO.File]::WriteAllText($Path, (ConvertTo-Json -InputObject $sorted) + "`n", [System.Text.UTF8Encoding]::new($false))
}
