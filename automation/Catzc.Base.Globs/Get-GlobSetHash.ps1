<#
.SYNOPSIS
    Computes a globset's durable SHA — the deployable unit's identity (ADR-GLOBS:5).
.DESCRIPTION
    The recipe: per member file, SHA-256 over the on-disk bytes with every CR (0x0D) stripped (a CRLF vs LF
    working tree yields the same identity on every machine); the per-file digests folded as
    <repo-relative-path>|<digest> lines in ordinal path order; one combined SHA-256 over the fold, returned
    as 64 lowercase hex chars — exactly the marker file's sha256 value (ADR-GLOBS:9). A
    tracked-but-missing-on-disk member (an unstaged deletion) folds the distinct marker <path>|missing
    instead of throwing, so a deletion re-keys the set. Because the path is part of the fold, a rename
    re-keys even on byte-identical content. When the working tree is clean in-scope, this equals the
    committed marker identity.
.PARAMETER Name
    The declared globset (from globs.yml) whose identity to compute.
.PARAMETER GlobSet
    A [Catzc.Base.Globs.GlobSet] instance to compute the identity for instead — the path a DERIVED set
    (Get-ModuleGlobSet) takes, since derived sets are not in the declared registry.
.EXAMPLE
    Get-GlobSetHash -Name automation
.EXAMPLE
    Get-GlobSetHash -GlobSet (Get-ModuleGlobSet -Name Catzc.Base.Globs)
#>
function Get-GlobSetHash {
    [CmdletBinding(DefaultParameterSetName = 'ByName')]
    [OutputType([string])]
    param(
        [Parameter(Mandatory, Position = 0, ParameterSetName = 'ByName')]
        [ArgumentCompleter({ (Get-Config -Config globs).Names })]
        [string] $Name,

        [Parameter(Mandatory, ParameterSetName = 'ByObject')]
        [Catzc.Base.Globs.GlobSet] $GlobSet
    )

    $root = Get-RepositoryRoot
    $members = if ($PSCmdlet.ParameterSetName -eq 'ByName') {
        Get-GlobSetFile -Name $Name
    }
    else {
        $matched = [System.Collections.Generic.List[string]]::new()
        foreach ($path in Get-TrackedFile) {
            if ($GlobSet.Matches($path)) {
                $matched.Add($path)
            }
        }
        $sorted = $matched.ToArray()
        [System.Array]::Sort($sorted, [System.StringComparer]::Ordinal)
        $sorted
    }

    $stringBuilder = [System.Text.StringBuilder]::new()
    foreach ($path in $members) {
        $digest = [Catzc.Base.Globs.DurableHash]::HashFile([System.IO.Path]::Combine($root, $path))
        if ($null -eq $digest) {
            # a tracked member deleted on disk but not staged: a distinct marker, so the deletion re-keys
            $digest = 'missing'
        }
        [void]$stringBuilder.Append($path).Append('|').Append($digest).Append("`n")
    }
    [Catzc.Base.Globs.DurableHash]::HashFold($stringBuilder.ToString())
}
