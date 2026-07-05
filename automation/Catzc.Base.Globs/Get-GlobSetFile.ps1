<#
.SYNOPSIS
    Returns the tracked files a globset matches — the deployable unit's actual members.
.DESCRIPTION
    Intersects the matching universe (`git ls-files`, ADR-GLOBS:4) with the named globset's membership
    (include minus exclude), ordinally sorted — the exact file list the durable SHA is computed over
    (ADR-GLOBS:5). A member may be missing on disk (an unstaged deletion); it is still a member here.
.PARAMETER Name
    The globset whose members to list.
.EXAMPLE
    Get-GlobSetFile -Name automation
#>
function Get-GlobSetFile {
    [CmdletBinding()]
    [OutputType([string[]])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [ArgumentCompleter({ (Get-Config -Config globs).Names })]
        [string] $Name
    )

    $set = Get-GlobSet -Name $Name
    $members = [System.Collections.Generic.List[string]]::new()
    foreach ($path in Get-TrackedFile) {
        if ($set.Matches($path)) {
            $members.Add($path)
        }
    }

    # Deterministic, culture-independent order (Sort-Object is culture-aware — cross-platform ADR).
    $sorted = $members.ToArray()
    [System.Array]::Sort($sorted, [System.StringComparer]::Ordinal)
    $sorted
}
