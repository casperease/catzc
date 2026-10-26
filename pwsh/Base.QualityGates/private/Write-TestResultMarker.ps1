<#
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-quality-gates/private/Write-TestResultMarker.ps1.md"
  header: "generated"
---
#>

function Write-TestResultMarker {
    [CmdletBinding()]
    [OutputType([string[]])]
    param(
        [Parameter(Mandatory)]
        [AllowEmptyCollection()]
        [object[]] $Outcome,

        [Parameter(Mandatory)]
        [string] $RunDirectory,

        # A filtered run says nothing of the other tests, so it never clears a marker.
        [switch] $KeepPassing,

        [string] $RepositoryRoot = (Get-RepositoryRoot),

        [string] $OutputRoot = (Get-OutputRoot)
    )

    # One marker per failing file at a fixed path; the lamps read only its existence and time.
    $markerRoot = Join-Path $OutputRoot 'test-results'
    $utf8NoBom = [System.Text.UTF8Encoding]::new($false)
    foreach ($item in $Outcome) {
        $relative = [System.IO.Path]::GetRelativePath($RepositoryRoot, $item.Path).Replace('\', '/')
        if ($relative.StartsWith('../') -or [System.IO.Path]::IsPathRooted($relative)) {
            continue
        }
        $marker = Join-Path $markerRoot "$relative.failed"
        if ($item.Failed) {
            [void][System.IO.Directory]::CreateDirectory([System.IO.Path]::GetDirectoryName($marker))
            [System.IO.File]::WriteAllText($marker, "$($item.FailedCount) failed; run $RunDirectory`n", $utf8NoBom)
            $marker
        }
        elseif (-not $KeepPassing -and [System.IO.File]::Exists($marker)) {
            [System.IO.File]::Delete($marker)
        }
    }
}
