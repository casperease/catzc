function Get-FrontPageRuleTitle {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory)]
        [string] $RecordPath,

        [Parameter(Mandatory)]
        [string] $Anchor
    )

    # A rule's short phrase is the text of the first decision link under it, which the record already words for a reader.
    $path = Resolve-RepoPath $RecordPath
    Assert-PathExist $path -PathType Leaf
    $lines = [System.IO.File]::ReadAllLines($path)
    $start = -1
    for ($i = 0; $i -lt $lines.Count; $i++) {
        if ($lines[$i] -match '^###\s+(?<slug>Rule\s+\S+)\s*$' -and ($Matches['slug'] -replace '\s+', '-').ToLowerInvariant() -ceq $Anchor) {
            $start = $i
            break
        }
    }
    Assert-True ($start -ge 0) -ErrorText "Get-FrontPageRuleTitle: '$RecordPath' has no rule heading for the anchor '$Anchor'."

    for ($j = $start + 1; $j -lt $lines.Count -and -not $lines[$j].StartsWith('#'); $j++) {
        if ($lines[$j] -match '^- \[(?<text>[^\]]+)\]\(#') {
            return $Matches['text']
        }
    }
    Get-FrontPageRecordTitle -RecordPath $RecordPath
}
