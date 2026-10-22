<#
---
catzc:
  immutable:
    with_body_sha: d69378f136e2
  edges:
    test: pwsh/Catzc.Base.QualityGates/tests/Get-DrsUsageRow.Tests.ps1
    docs: "[Get-DrsUsageRow.ps1.md](../../../docs/references/pwsh/catzc-base-quality-gates/private/Get-DrsUsageRow.ps1.md)"
    cites:
      - ADR-REPO-FILEMETA-NOREADBACK
---
#>

function Get-DrsUsageRow {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Mandatory)]
        [AllowEmptyString()]
        [string] $Text,

        [Parameter(Mandatory)]
        [string] $Path,

        [Parameter(Mandatory)]
        [Catzc.Base.Drs.DrsCitationMap] $Map,

        [Parameter(Mandatory)]
        [Catzc.Base.QualityGates.FileMetaKind] $Kind,

        [Parameter(Mandatory)]
        [Catzc.Base.CodeMeta.CommentPagesConfig] $Pages,

        [Catzc.Base.CodeMeta.HeadForm] $Form
    )

    # The rows come from the file's text through the processors the imprint uses, never from its head.
    $citesKind = $Kind
    $isCode = $PSBoundParameters.ContainsKey('Form')
    $state = if ($isCode) {
        Get-CodeMetaState -Text $Text -Form $Form
    }
    else {
        Get-MarkdownMetaState -Text $Text
    }
    $adrs = @((Get-DrsCodesFileMetaFact -State $state -Path $Path -Kind $citesKind)[$citesKind.keys[0]])
    $links = if ($isCode) {
        @()
    }
    else {
        @([Catzc.Base.QualityGates.DocumentLinks]::Of($state.Body, $Path, (Get-CommentPage -Path $Path -Config $Pages)))
    }

    foreach ($citation in $adrs) {
        # A fixture code or a placeholder named in a comment is no usage of an ADR.
        if (-not ($Map.HasCode($citation) -or $Map.IsDomainCode($citation))) {
            continue
        }
        $isRule = $Map.IsRule($citation)
        [pscustomobject]@{
            Path   = $Path
            Code   = if ($isRule) {
                $Map.AdrOf($citation)
            }
            else {
                $citation
            }
            Rule   = if ($isRule) {
                $citation
            }
            else {
                $null
            }
            Source = 'cites'
        }
    }

    foreach ($link in $links) {
        $target, $anchor = $link -split '#', 2
        $code = $Map.CodeOf($target)
        if (-not $code) {
            continue
        }
        [pscustomobject]@{ Path = $Path; Code = $code; Rule = $Map.RuleOfAnchor($code, $anchor); Source = 'link' }
    }
}
