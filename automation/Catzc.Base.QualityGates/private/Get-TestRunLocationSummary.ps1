<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/private/Get-TestRunLocationSummary.ps1
    kind: function
    module: Catzc.Base.QualityGates
    visibility: private
---
#>

<#
.SYNOPSIS
    Renders where a test run executed, for the report header and the run manifest.
.DESCRIPTION
    No location (a fully protected run, or crashed workers) gives empty text and no entries, not an error.
    [comment:1](/docs/references/automation/catzc-base-qualitygates/private/Get-TestRunLocationSummary.ps1.md#comment1)
.PARAMETER Location
    The location the worker run executed in (Enter-TestRunLocation's object), or $null.
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
