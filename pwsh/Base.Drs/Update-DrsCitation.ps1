function Update-DrsCitation {
    [CmdletBinding()]
    [OutputType([Catzc.Base.Drs.DrsCitationChange])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $Path,

        [Parameter(Mandatory)]
        [string] $CodeMap,

        [Parameter(Mandatory)]
        [string] $RuleMap,

        [string] $RepositoryRoot = (Get-RepositoryRoot),

        [string[]] $Exclude = @('.claude/learnings/', '.claude/hindsight/'),

        [switch] $DryRun
    )

    $root = [System.IO.Path]::GetFullPath($RepositoryRoot)
    $file = if ([System.IO.Path]::IsPathRooted($Path)) {
        [System.IO.Path]::GetFullPath($Path)
    }
    else {
        [System.IO.Path]::GetFullPath([System.IO.Path]::Combine($root, $Path))
    }
    Assert-PathExist $file -PathType Leaf
    $repoPath = [System.IO.Path]::GetRelativePath($root, $file).Replace('\', '/')
    $isOutside = $repoPath -eq '..' -or $repoPath.StartsWith('../') -or [System.IO.Path]::IsPathRooted($repoPath)
    Assert-False $isOutside -ErrorText "$file is outside the repository root $root"
    if (@($Exclude | Where-Object { $repoPath.StartsWith($_, [System.StringComparison]::Ordinal) }).Count) {
        return
    }

    $codeRows = Import-DrsCitationMapFile (Resolve-RepoPath $CodeMap) -Header 'old_code', 'new_code', 'old_path', 'new_path', 'kind'
    $ruleRows = Import-DrsCitationMapFile (Resolve-RepoPath $RuleMap) -Header 'old_rule', 'new_rule', 'kind', 'why'
    $citations = Get-DrsCitationMap -RepositoryRoot $root
    $records = (Get-Config -Config drs).Root
    $drsRoot = Join-Path $root $records
    $treeFiles = [string[]] @(if (Test-Path -LiteralPath $drsRoot -PathType Container) {
            foreach ($recordFile in Get-ChildPath $drsRoot -File -Depth 8) {
                [System.IO.Path]::GetRelativePath($root, $recordFile).Replace('\', '/')
            }
        })
    # A markdown file's citations take the reference form where a respelled line outgrows the file's declared width.
    $markdownWidth = if ($repoPath.EndsWith('.md', [System.StringComparison]::OrdinalIgnoreCase)) {
        [int] (Get-FileLimit -Path $repoPath).width
    }
    else {
        0
    }
    $rewriter = [Catzc.Base.Drs.DrsCitationRewriter]::new($codeRows, $ruleRows, $citations, $treeFiles,
        (Get-Config -Config drs).Kinds, $records, $markdownWidth)

    # Decoded strictly, so a file that is not UTF-8 fails instead of being re-encoded; a byte order mark is written back as it was.
    $bytes = [System.IO.File]::ReadAllBytes($file)
    $hasBom = $bytes.Length -ge 3 -and $bytes[0] -eq 0xEF -and $bytes[1] -eq 0xBB -and $bytes[2] -eq 0xBF
    $offset = if ($hasBom) {
        3
    }
    else {
        0
    }
    $encoding = [System.Text.UTF8Encoding]::new($false, $true)
    $text = $encoding.GetString($bytes, $offset, $bytes.Length - $offset)

    $rewrite = $rewriter.Rewrite($text, $repoPath)
    foreach ($change in $rewrite.Changes) {
        if ($change.Kind -eq [Catzc.Base.Drs.DrsCitationChangeKind]::Unhandled) {
            Write-Message -Warning "${repoPath}:$($change.Line): left as written, a range spans a moved rule: $($change.Old)"
        }
    }

    if ($rewrite.Changed -and -not $DryRun) {
        $body = $encoding.GetBytes($rewrite.Text)
        $output = [byte[]]::new($offset + $body.Length)
        [System.Array]::Copy($bytes, $output, $offset)
        [System.Array]::Copy($body, 0, $output, $offset, $body.Length)
        [System.IO.File]::WriteAllBytes($file, $output)
    }

    $rewrite.Changes
}
