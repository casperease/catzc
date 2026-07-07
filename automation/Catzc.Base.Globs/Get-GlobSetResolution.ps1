<#
.SYNOPSIS
    Resolves a globset over the working tree into its member file list, count, and list-identity SHA
    (ADR-GLOBS:11).
.DESCRIPTION
    Runs the set's scan program against `git ls-files` and returns:
      - Included  : the git-bound files IN the package — the tracked files GlobSet.Matches selects
                    (Get-GlobSetMember), ordinal-sorted. This is exactly the durable-SHA input; ScopedSha is
                    its list SHA and Count its size.
      - Count     : the number of Included files — the marker's readable `files:` digest.
      - ScopedSha : the ordered member-path list SHA (DurableHash.HashPathList) — the marker's scoped_sha256.
    Everything here is deterministic and bound to the committed file NAMES: the resolution is reproducible from
    the tree on any machine. The expanded Included list is written to the transient out/ folder by
    Write-CompanionFile; the marker itself carries only Count + ScopedSha (+ the durable sha256), never the
    list. Tracked files a '-' exclude drops are simply not members (the scan '-' lines document them).
.PARAMETER Name
    A declared globset name (from globs.yml).
.PARAMETER GlobSet
    A [Catzc.Base.Globs.GlobSet] instance — the path a derived set (Get-ModuleGlobSet) takes.
.EXAMPLE
    Get-GlobSetResolution -Name apex
.EXAMPLE
    (Get-GlobSetResolution -GlobSet (Get-ModuleGlobSet -Name Catzc.Base.Globs)).Count
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

    $included = [string[]] (Get-GlobSetMember -GlobSet $set)

    [pscustomobject]@{
        Name      = $set.Name
        Included  = $included
        Count     = $included.Count
        ScopedSha = [Catzc.Base.Globs.DurableHash]::HashPathList($included)
    }
}
