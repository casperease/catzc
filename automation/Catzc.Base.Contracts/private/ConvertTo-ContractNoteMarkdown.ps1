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
---
#>

<#
.SYNOPSIS
    Turns a contract asset's note into the markdown text of its list item on a generated page.
.DESCRIPTION
    A note is a comment where a citation is a repository-rooted link, so on a page each link becomes page-relative.
.PARAMETER Note
    The note, one line.
.PARAMETER PageFolder
    The repository-relative folder of the page the note is written to, '/'-separated.
.OUTPUTS
    [string] The note as markdown.
.EXAMPLE
    ConvertTo-ContractNoteMarkdown -Note $note -PageFolder 'docs/references/contracts'
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
