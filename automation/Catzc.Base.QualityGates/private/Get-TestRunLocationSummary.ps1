<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/private/Get-TestRunLocationSummary.ps1
    kind: function
    language: powershell
    filekind: ps1
    track: automation
    module: Catzc.Base.QualityGates
    visibility: private
    relatives:
      test: automation/Catzc.Base.QualityGates/tests/Get-TestRunLocationSummary.Tests.ps1
  config:
    synopsis: Renders where a test run executed, for the report header and the run manifest.
    description: |-
      One reading of the location a worker run executed in — the run's location from Enter-TestRunLocation,
      which Invoke-TestAutomationWorkers returns as its Location — in the two shapes its consumers need: a
      one-line text for summary.md's Location line, and the run.json entries — `location` (the location's Mode,
      'in-place' or 'snapshot') plus, for a snapshot, its provenance (path, source root, commit, change counts,
      whether it was kept, and who held the working folder). No location (a fully protected run executed
      nowhere, or the workers crashed) renders as empty text and no entries.
    parameters:
      Location: The location the worker run executed in (Enter-TestRunLocation's object), or $null.
    outputs: '[pscustomobject] with Text ([string]) and Manifest ([ordered] entries to merge into run.json).'
---
#>

function Get-TestRunLocationSummary {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [AllowNull()]
        [object] $Location
    )

    $manifest = [ordered]@{}
    if (-not $Location) {
        return [pscustomobject]@{ Text = ''; Manifest = $manifest }
    }

    $manifest['location'] = $Location.Mode
    $text = $Location.Mode
    if ($Location.Snapshot) {
        $snapshot = $Location.Snapshot
        $fate = if ($Location.KeepSandbox) {
            'kept'
        }
        else {
            'removed'
        }
        $text = '{0} of {1} @ {2} + {3} modified, {4} untracked, {5} deleted file(s) in {6} ({7})' -f $Location.Mode,
        $snapshot.SourceRoot, $snapshot.Commit.Substring(0, [Math]::Min(7, $snapshot.Commit.Length)),
        $snapshot.Modified, $snapshot.Untracked, $snapshot.Deleted, $snapshot.Path, $fate
        $manifest['snapshot'] = [ordered]@{
            path       = $snapshot.Path
            sourceRoot = $snapshot.SourceRoot
            commit     = $snapshot.Commit
            modified   = $snapshot.Modified
            untracked  = $snapshot.Untracked
            deleted    = $snapshot.Deleted
            kept       = [bool] $Location.KeepSandbox
            holder     = $(if ($Location.Holder) {
                    $Location.Holder.Description
                }
                else {
                    $null
                })
        }
    }
    [pscustomobject]@{ Text = $text; Manifest = $manifest }
}
