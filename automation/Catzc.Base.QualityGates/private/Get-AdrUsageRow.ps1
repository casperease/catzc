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

    foreach ($token in $adrs) {
        foreach ($citation in [Catzc.Base.Docs.AdrCodeForm]::Expand($token)) {
            $code, $rule = $citation -split '#', 2
            $registered = if ($rule) {
                $Map.HasRule($code, [int] $rule)
            }
            else {
                $Map.HasCode($code) -or $Map.IsDomainCode($code)
            }
            # A fixture code or a placeholder named in a comment is no usage of an ADR.
            if (-not $registered) {
                continue
            }
            [pscustomobject]@{
                Path   = $Path
                Code   = $code
                Rule   = if ($rule) {
                    [int] $rule
                }
                else {
                    $null
                }
                Source = 'cites'
            }
        }
    }

    foreach ($link in $links) {
        $target, $anchor = $link -split '#', 2
        $code = $Map.CodeOf($target)
        if (-not $code) {
            continue
        }
        $prefix = 'rule-' + $code.ToLowerInvariant()
        $rule = $null
        if ($anchor -and $anchor.StartsWith($prefix, [System.StringComparison]::Ordinal)) {
            $number = 0
            if ([int]::TryParse($anchor.Substring($prefix.Length), [ref] $number)) {
                $rule = $number
            }
        }
        [pscustomobject]@{ Path = $Path; Code = $code; Rule = $rule; Source = 'link' }
    }
}
