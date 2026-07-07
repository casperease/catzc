<#
.SYNOPSIS
    The tracked files a globset finally selects — the single source of a set's included members.
.DESCRIPTION
    The one definition of "what is IN the package" (ADR-GLOBS:4): the matching universe (`git ls-files`)
    intersected with the set's final membership (GlobSet.Matches, last-match-wins), ordinal-sorted. Every
    consumer of the member list routes through here — the durable content SHA (Get-GlobSetHash), the public
    Get-GlobSetFile, and the resolution (Get-GlobSetResolution) — so the scoped list can never drift between
    the hash, the marker's scoped_sha256, and the companion's included list. A member may be missing on disk
    (an unstaged deletion); it is still a member.
.PARAMETER GlobSet
    The globset instance to resolve (declared or derived).
.EXAMPLE
    Get-GlobSetMember -GlobSet (Get-GlobSet -Name automation)
#>
function Get-GlobSetMember {
    [CmdletBinding()]
    [OutputType([string[]])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [Catzc.Base.Globs.GlobSet] $GlobSet
    )

    $members = [System.Collections.Generic.List[string]]::new()
    foreach ($path in Get-TrackedFile) {
        if ($GlobSet.Matches($path)) {
            $members.Add($path)
        }
    }

    # Deterministic, culture-independent order (Sort-Object is culture-aware — cross-platform ADR).
    $sorted = $members.ToArray()
    [System.Array]::Sort($sorted, [System.StringComparer]::Ordinal)
    $sorted
}
