<#
.SYNOPSIS
    Computes a globset's durable SHA — the deployable unit's identity (ADR-GLOBS:5).
.DESCRIPTION
    The recipe: per member file, SHA-256 over the on-disk bytes with every CR (0x0D) stripped (a CRLF vs LF
    working tree yields the same identity on every machine); the per-file digests folded as
    <repo-relative-path>|<digest> lines in ordinal path order; one combined SHA-256 over the fold, returned
    as 64 lowercase hex chars — exactly the trigger-file content. A tracked-but-missing-on-disk member (an
    unstaged deletion) folds the distinct marker <path>|missing instead of throwing, so a deletion re-keys
    the set. Because the path is part of the fold, a rename re-keys even on byte-identical content. When the
    working tree is clean in-scope, this equals the committed trigger identity byte-for-byte.
.PARAMETER Name
    The globset whose identity to compute.
.EXAMPLE
    Get-GlobSetHash -Name automation
#>
function Get-GlobSetHash {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [ArgumentCompleter({ (Get-Config -Config globs).Names })]
        [string] $Name
    )

    $root = Get-RepositoryRoot
    $members = Get-GlobSetFile -Name $Name

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
