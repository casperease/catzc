<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/private/Get-AdrUsageRow.ps1
    kind: automation-function
    language: powershell
    track: automation
    module: Catzc.Base.QualityGates
    visibility: private
    relatives:
      test: automation/Catzc.Base.QualityGates/tests/Get-AdrUsageRow.Tests.ps1
  config:
    synopsis: The ADR citations one file's meta head holds, as rows of code and rule.
    description: |-
      Pure: it takes the text, the path and the citation map, and reads no file. The `adrs` list of the head gives one row per citation,
      a group such as `ADR-X#{1,3}` expanded to its rules and a bare code kept as the whole ADR (Rule is null). The `links` list gives a row
      for every link into a registered ADR, with the rule its anchor names (Rule is null for a link to the ADR itself). A link to a
      document under docs/adr/ that no code owns, such as the index, gives no row.
    parameters:
      Text: The whole file as text.
      Path: The file's repository-relative path.
      Map: The ADR citation map.
      Form: The comment syntax of a code file's head (a Catzc.Base.CodeMeta.HeadForm). Omitted for a Markdown file, which carries its block in front matter.
    outputs: '[pscustomobject[]] @{ Path; Code; Rule; Source } with Source `head` or `link`.'
---
#>

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
        $lists = (Get-CodeMetaState -Text $Text -Form $Form).DerivedLists
        $adrs = if ($lists.Contains('adrs')) {
            $lists['adrs']
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
        $adrs = [Catzc.Base.MarkdownMeta.MarkdownMetaBlock]::DerivedList($block, 'adrs')
        $links = [Catzc.Base.MarkdownMeta.MarkdownMetaBlock]::DerivedList($block, 'links')
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
