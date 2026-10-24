function Write-TestResultMarker {
    [CmdletBinding()]
    [OutputType([string[]])]
    param(
        [Parameter(Mandatory)]
        [AllowEmptyCollection()]
        [object[]] $Outcome,

        [Parameter(Mandatory)]
        [string] $RunDirectory,

        # A run filtered to some tests says nothing of the others, so it only records failures and never clears a marker.
        [switch] $KeepPassing,

        [string] $RepositoryRoot = (Get-RepositoryRoot),

        [string] $OutputRoot = (Get-OutputRoot)
    )

    # One marker per failing test file at a fixed path, out/test-results/<repository path of the test file>.failed, so a reader (the
    # editor's lamps) needs only its existence and its timestamp; a passing file's marker is deleted. Returns the markers written.
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
