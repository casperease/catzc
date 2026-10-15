<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Contracts/private/ConvertTo-ContractNoteMarkdown.ps1
    kind: private-function
    module: Catzc.Base.Contracts
    visibility: private
    adrs:
      - ADR-REPO-LINK#2
      - ADR-REPO-LINK#3
  config:
    synopsis: Turns a contract asset's note into the markdown text of its list item on a generated page.
    description: |-
      A note is written as a comment (Get-ContractAssetNote), where an ADR citation is a repository-rooted code link
      ([ADR-REPO-LINK#3](/docs/adr/repository/markdown-links.md#rule-adr-repo-link3)). On the generated page it is markdown,
      so each part is rewritten to its markdown form:
      - a link whose destination starts with '/' becomes relative to the page's folder, its #fragment kept
        ([ADR-REPO-LINK#2](/docs/adr/repository/markdown-links.md#rule-adr-repo-link2));
      - a bare https:// or http:// address becomes an autolink, <address>, so it renders as a link and is not a bare URL;
      - a '<' that opens no autolink is escaped, so it is never read as inline HTML.
      Code spans keep their text; every other link and autolink is left as written.
    parameters:
      Note: The note, one line.
      PageFolder: The repository-relative folder of the page the note is written to, '/'-separated.
    outputs: '[string] The note as markdown.'
    examples:
      - ConvertTo-ContractNoteMarkdown -Note $note -PageFolder 'docs/references/contracts'
---
#>

function ConvertTo-ContractNoteMarkdown {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory)]
        [string] $Note,

        [Parameter(Mandatory)]
        [string] $PageFolder
    )

    $pageRoot = "/$PageFolder"
    $parts = '(?<code>`[^`]*`)|(?<link>\[[^\]]*\]\((?<dest>[^)\s]+)\))|(?<auto><https?://[^>\s]+>)|(?<url>https?://[^\s<>|]*[^\s<>|.,;:!?)])|(?<lt><)'
    $markdown = [regex]::Replace($Note, $parts, {
            param([System.Text.RegularExpressions.Match] $part)
            if ($part.Groups['link'].Success) {
                $destination = $part.Groups['dest'].Value
                if (-not $destination.StartsWith('/') -or $destination.StartsWith('//')) {
                    return $part.Value
                }
                $hashAt = $destination.IndexOf('#')
                $file = if ($hashAt -ge 0) {
                    $destination.Substring(0, $hashAt)
                }
                else {
                    $destination
                }
                $fragment = if ($hashAt -ge 0) {
                    $destination.Substring($hashAt)
                }
                else {
                    ''
                }
                $relative = [System.IO.Path]::GetRelativePath($pageRoot, $file).Replace('\', '/')
                return $part.Value.Substring(0, $part.Value.Length - $destination.Length - 1) + $relative + $fragment + ')'
            }
            if ($part.Groups['url'].Success) {
                return "<$($part.Value)>"
            }
            if ($part.Groups['lt'].Success) {
                return '\<'
            }
            $part.Value
        })
    $markdown
}
