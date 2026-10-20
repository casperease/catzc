<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.Contracts/private/ConvertTo-ContractNoteMarkdown.ps1
    folder: private
    name: convert-to-contract-note-markdown
    filetype: ps1
    role: function
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Base.Contracts
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: private
  edges:
    test: pwsh/Catzc.Base.Contracts/tests/ConvertTo-ContractNoteMarkdown.Tests.ps1
    docs: "[ConvertTo-ContractNoteMarkdown.ps1.md](docs/references/pwsh/catzc-base-contracts/private/ConvertTo-ContractNoteMarkdown.ps1.md)"
    cites:
      - ADR-REPO-LINK-MARKDOWNRELATIVE
      - ADR-REPO-LINK-CODELINKS
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
