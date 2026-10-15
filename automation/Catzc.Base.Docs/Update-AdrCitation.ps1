<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Docs/Update-AdrCitation.ps1
    kind: function
    module: Catzc.Base.Docs
    visibility: public
---
#>

<#
.SYNOPSIS
    Rewrites the ADR citations, codes, anchors, links, and paths in one file through a code map and a rule map.
.DESCRIPTION
    A citation range spanning a moved rule is left as written and returned Unhandled, for a person to resolve.
    [ADR-AUTO-IDEM](/docs/adr/automation/idempotent-state-functions.md),
    [ADR-REPO-LINK#2](/docs/adr/repository/markdown-links.md#rule-adr-repo-link2)
    [comment:1](/docs/references/automation/catzc-base-docs/Update-AdrCitation.ps1.md#comment1)
.PARAMETER Path
    The one file to rewrite: absolute, or relative to the repository root. It must be inside the repository root.
.PARAMETER CodeMap
    The code map file (absolute, repository-relative, or under out/).
.PARAMETER RuleMap
    The rule map file (absolute, repository-relative, or under out/).
.PARAMETER RepositoryRoot
    Relative links and -Path resolve against this root, so another root changes where a rewritten link lands.
    [comment:2](/docs/references/automation/catzc-base-docs/Update-AdrCitation.ps1.md#comment2)
.PARAMETER DryRun
    The returned changes are the ones a real run would make, so a dry run is a safe preview of a migration.
    [ADR-AUTO-DRYRUN](/docs/adr/automation/dry-run.md)
    [comment:3](/docs/references/automation/catzc-base-docs/Update-AdrCitation.ps1.md#comment3)
.OUTPUTS
    [Catzc.Base.Docs.AdrCitationChange] One per rewritten (or Unhandled) reference, in file order.
.EXAMPLE
    Update-AdrCitation 'docs/index.md' -CodeMap 'out/split/code-map.tsv' -RuleMap 'out/split/rule-moves.tsv' -DryRun
    Lists what would change in docs/index.md without writing it.
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
    $rewriter = [Catzc.Base.Docs.AdrCitationRewriter]::new($codeRows, $ruleRows, $citations)

    # Strict decoding fails a non-UTF-8 file here instead of re-encoding it; the BOM is kept aside and restored.
    # [comment:4](/docs/references/automation/catzc-base-docs/Update-AdrCitation.ps1.md#comment4)
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
