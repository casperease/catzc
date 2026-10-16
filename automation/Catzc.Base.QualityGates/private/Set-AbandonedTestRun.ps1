<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/private/Set-AbandonedTestRun.ps1
    folder: private
    name: set-abandoned-test-run
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    module: Catzc.Base.QualityGates
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: private
    relatives:
      page: docs/references/automation/catzc-base-qualitygates/private/Set-AbandonedTestRun.ps1.md
      test: automation/Catzc.Base.QualityGates/tests/Set-AbandonedTestRun.Tests.ps1
  config:
    synopsis: Marks every run under a report folder that says 'running' but whose owning process is gone as 'abandoned'.
    description: |-
      A run stamps run.json 'running' at start and a terminal status in a finally (Write-TestRunManifest). When the
      owning process itself dies — a closed terminal, a killed console — the finally never runs, and the manifest
      would claim 'running' forever. A run records its owner (ownerPid, ownerStart — the start time tells a reused
      PID apart, WorkerParentWatch.IsAlive), so the next run in the same report folder sweeps the folder first: each
      'running' manifest whose owner is no longer alive is rewritten as 'abandoned' (the rest of its content kept,
      plus abandonedAt), with one announcement line per run. A 'running' manifest that names no owner has no live
      owner to protect and is abandoned too. A live owner's run, and every terminal status, is left untouched.

      Best-effort per run: an unreadable or unparseable run.json is skipped, never fails the run that sweeps.
    parameters:
      OutputFolder: The report base folder whose run directories (<OutputFolder>/<stamp>/run.json) are swept.
    outputs: '[string] Each run directory marked abandoned.'
    examples:
      - Set-AbandonedTestRun -OutputFolder (Join-Path (Get-OutputRoot) 'test-automation')
---
#>

function Set-AbandonedTestRun {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessForStateChangingFunctions', '', Justification = 'Rewrites run records under out/ only — the gitignored output folder — as an automatic step of starting a run; nothing user-owned changes.')]
    [OutputType([string])]
    param(
        [Parameter(Mandatory)]
        [string] $OutputFolder
    )

    if (-not [System.IO.Directory]::Exists($OutputFolder)) {
        return
    }

    foreach ($runDirectory in [System.IO.Directory]::EnumerateDirectories($OutputFolder)) {
        $manifestPath = [System.IO.Path]::Combine($runDirectory, 'run.json')
        if (-not [System.IO.File]::Exists($manifestPath)) {
            continue
        }
        try {
            $manifest = [System.IO.File]::ReadAllText($manifestPath) | ConvertFrom-Json -AsHashtable
        }
        catch {
            Write-Verbose "Skipped unreadable run manifest: $manifestPath — $($_.Exception.Message)"
            continue
        }
        if ($manifest -isnot [System.Collections.IDictionary] -or $manifest['status'] -ne 'running') {
            continue
        }

        $ownerPid = $manifest['ownerPid']
        $ownerStart = $manifest['ownerStart']
        if ($null -ne $ownerPid -and $null -ne $ownerStart -and
            [Catzc.Base.QualityGates.WorkerParentWatch]::IsAlive([int]$ownerPid, [long]$ownerStart)) {
            continue
        }

        $abandoned = [ordered]@{}
        foreach ($key in $manifest.Keys) {
            $value = $manifest[$key]
            if ($value -is [datetime] -or $value -is [System.DateTimeOffset]) {
                $value = ([System.DateTimeOffset] $value).ToUniversalTime().ToString('o')
            }
            $abandoned[$key] = $value
        }
        $abandoned['status'] = 'abandoned'
        $abandoned['abandonedAt'] = [DateTimeOffset]::UtcNow.ToString('o')
        Write-TestRunManifest -RunDirectory $runDirectory -Manifest $abandoned | Out-Null

        $owner = if ($null -ne $ownerPid) {
            "its owner (PID $ownerPid) is gone"
        }
        else {
            'it names no owner'
        }
        Write-Message "Marked run $([System.IO.Path]::GetFileName($runDirectory)) abandoned — $owner"
        $runDirectory
    }
}
