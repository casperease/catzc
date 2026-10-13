<#
.SYNOPSIS
    Renders where a test run executed, for the report header and the run manifest.
.DESCRIPTION
    One reading of a worker run's Location (Invoke-TestAutomationWorkers), in the two shapes its consumers
    need: a one-line text for summary.md's Location line, and the run.json entries — `location` ('in-place'
    or 'snapshot') plus, for a snapshot, its provenance (path, source root, commit, change counts, whether it
    was kept, and who held the working folder). No location (a fully protected run executed nowhere, or the
    workers crashed) renders as empty text and no entries.
.PARAMETER Location
    The worker run's Location object, or $null.
.OUTPUTS
    [pscustomobject] with Text ([string]) and Manifest ([ordered] entries to merge into run.json).
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
        $fate = if ($Location.Kept) {
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
            kept       = [bool] $Location.Kept
            holder     = $Location.Holder
        }
    }
    [pscustomobject]@{ Text = $text; Manifest = $manifest }
}
