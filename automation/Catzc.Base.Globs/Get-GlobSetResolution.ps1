<#
.SYNOPSIS
    Resolves a globset over the working tree into its two file lists plus their list-identity SHAs
    (ADR-GLOBS:11).
.DESCRIPTION
    Runs the set's scan program against the working tree and returns:
      - Included  : the git-bound files IN the package — `git ls-files` intersected with GlobSet.Matches
                    (Get-GlobSetMember). This is exactly the durable-SHA input; ScopedSha is its list SHA.
      - Filtered  : the NON-GIT files the includes touch — untracked/ignored working-tree files
                    (Get-UntrackedFile) matched by the include footprint (GlobSet.IncludeTouches). This is
                    "what is on disk but NOT in the package"; FilteredSha is its list SHA.
    ScopedSha equals the marker's scoped_sha256; the whole result is the source for the gitignored companion
    (.sha-markers/<name>.files.yml). Filtered is a fact of the local tree — not reproducible — so it never
    reaches a marker or a durable SHA. Tracked files a '-' exclude drops are in NEITHER list (the scan '-'
    lines document them).
.PARAMETER Name
    A declared globset name (from globs.yml).
.PARAMETER GlobSet
    A [Catzc.Base.Globs.GlobSet] instance — the path a derived set (Get-ModuleGlobSet) takes.
.EXAMPLE
    Get-GlobSetResolution -Name apex
.EXAMPLE
    (Get-GlobSetResolution -GlobSet (Get-ModuleGlobSet -Name Catzc.Base.Globs)).Included
#>
function Get-GlobSetResolution {
    [CmdletBinding(DefaultParameterSetName = 'ByName')]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Mandatory, Position = 0, ParameterSetName = 'ByName')]
        [ArgumentCompleter({ (Get-Config -Config globs).Names })]
        [string] $Name,

        [Parameter(Mandatory, ParameterSetName = 'ByObject')]
        [Catzc.Base.Globs.GlobSet] $GlobSet
    )

    $set = if ($PSCmdlet.ParameterSetName -eq 'ByName') {
        Get-GlobSet -Name $Name
    }
    else {
        $GlobSet
    }

    $included = Get-GlobSetMember -GlobSet $set

    $filteredList = [System.Collections.Generic.List[string]]::new()
    foreach ($path in Get-UntrackedFile) {
        if ($set.IncludeTouches($path)) {
            $filteredList.Add($path)
        }
    }
    $filtered = $filteredList.ToArray()
    [System.Array]::Sort($filtered, [System.StringComparer]::Ordinal)

    [pscustomobject]@{
        Name        = $set.Name
        Included    = [string[]] $included
        Filtered    = [string[]] $filtered
        ScopedSha   = [Catzc.Base.Globs.DurableHash]::HashPathList([string[]] $included)
        FilteredSha = [Catzc.Base.Globs.DurableHash]::HashPathList([string[]] $filtered)
    }
}
