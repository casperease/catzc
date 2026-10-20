<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.QualityGates/private/Get-TestRunLocationSummary.ps1
    folder: private
    name: get-test-run-location-summary
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
    test: pwsh/Catzc.Base.QualityGates/tests/Get-TestRunLocationSummary.Tests.ps1
    docs: "[Get-TestRunLocationSummary.ps1.md](docs/references/pwsh/catzc-base-qualitygates/private/Get-TestRunLocationSummary.ps1.md)"
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
