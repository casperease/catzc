function Get-AdrUsageRow {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Mandatory)]
        [AllowEmptyString()]
        [string] $Text,

        [Parameter(Mandatory)]
        [string] $Path,

        [Parameter(Mandatory)]
        [Catzc.Base.Docs.AdrCitationMap] $Map,

        [Catzc.Base.CodeMeta.HeadForm] $Form
    )

    # The rows come from the file's text through the processors the imprint uses, never from its head.
    $kinds = (Get-Config -Config file-meta).kinds
    $citesKind = $kinds | Where-Object { $_.id -eq 'adr-codes' }
    $linksKind = $kinds | Where-Object { $_.id -eq 'links' }
    $isCode = $PSBoundParameters.ContainsKey('Form')
    $state = if ($isCode) {
        Get-CodeMetaState -Text $Text -Form $Form
    }
    else {
        Get-MarkdownMetaState -Text $Text
    }
    $adrs = @((Get-AdrCodesFileMetaFact -State $state -Path $Path -Kind $citesKind)[$citesKind.keys[0]])
    $links = if ($isCode) {
        @()
    }
    else {
        @((Get-LinksFileMetaFact -State $state -Path $Path -Kind $linksKind)[$linksKind.keys[0]])
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
