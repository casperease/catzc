<#
---
catzc:
  immutable:
    with_body_sha: b56f1b8df323
  edges:
    test: pwsh/Catzc.Base.Docs/tests/Update-AdrCitation.Tests.ps1
    docs: "[Update-AdrCitation.ps1.md](docs/references/pwsh/catzc-base-docs/Update-AdrCitation.ps1.md)"
    cites:
      - ADR-AUTO-DRYRUN
      - ADR-AUTO-IDEM
      - ADR-REPO-LINK-MARKDOWNRELATIVE
---
#>

function Update-AdrCitation {
    [CmdletBinding()]
    [OutputType([Catzc.Base.Docs.AdrCitationChange])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $Path,

        [Parameter(Mandatory)]
        [string] $CodeMap,

        [Parameter(Mandatory)]
        [string] $RuleMap,

        [string] $RepositoryRoot = (Get-RepositoryRoot),

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

    $codeRows = Import-AdrCitationMapFile (Resolve-RepoPath $CodeMap) -Header 'old_code', 'new_code', 'old_path', 'new_path', 'kind'
    $ruleRows = Import-AdrCitationMapFile (Resolve-RepoPath $RuleMap) -Header 'old_rule', 'new_rule', 'kind', 'why'
    $citations = Get-AdrCitationMap -RepositoryRoot $root
    $adrRoot = Join-Path $root 'docs/adr'
    $treeFiles = [string[]] @(if (Test-Path -LiteralPath $adrRoot -PathType Container) {
            foreach ($adrFile in Get-ChildPath $adrRoot -File -Depth 8) {
                [System.IO.Path]::GetRelativePath($root, $adrFile).Replace('\', '/')
            }
        })
    $rewriter = [Catzc.Base.Docs.AdrCitationRewriter]::new($codeRows, $ruleRows, $citations, $treeFiles)

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
        if ($change.Kind -eq [Catzc.Base.Docs.AdrCitationChangeKind]::Unhandled) {
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
