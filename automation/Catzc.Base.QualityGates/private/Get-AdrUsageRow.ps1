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

    if ($PSBoundParameters.ContainsKey('Form')) {
        $lists = (Get-CodeMetaState -Text $Text -Form $Form).EdgeLists
        $adrs = if ($lists.Contains('cites')) {
            $lists['cites']
        }
        else {
            @()
        }
        $links = if ($lists.Contains('links')) {
            $lists['links']
        }
        else {
            @()
        }
    }
    else {
        $block = [Catzc.Base.MarkdownMeta.MarkdownDocument]::Parse($Text).MetaBlock
        $adrs = [Catzc.Base.MarkdownMeta.MarkdownMetaBlock]::EdgeList($block, 'cites')
        $links = [Catzc.Base.MarkdownMeta.MarkdownMetaBlock]::EdgeList($block, 'links')
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
                Source = 'head'
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
